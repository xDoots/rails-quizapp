class QuizAttemptsController < ApplicationController
  before_action :set_quiz, only: [ :new, :create ]

  def take
    @quiz = Quiz.find(params[:id])
  end

  def new
    # @quiz is set by before_action
  end

  def create
    answers = params[:answers] || {}
    if answers.keys.sort != @quiz.questions.pluck(:id).map(&:to_s).sort
      flash.now[:alert] = "Please answer all questions."
      render "quizzes/take", status: :unprocessable_entity, locals: { submitted_answers: answers }
      return
    end
    score = 0
    # We'll record answer ids to persist after creating the attempt.
    answers_to_persist = {}

    answers.each do |question_id, opt_param|
      question = Question.find(question_id)

      case question.question_type.to_s
      when "single_choice"
        selected_id = Array(opt_param).first.to_i
        option = Option.find_by(id: selected_id)
        score += question.points if option&.is_correct?
        answers_to_persist[question_id] = Array(selected_id)

      when "multiple_choice"
        selected_ids = Array(opt_param).map(&:to_i)
        correct_ids  = question.options.where(is_correct: true).pluck(:id)
        score += question.points if selected_ids.sort == correct_ids.sort
        answers_to_persist[question_id] = selected_ids

      when "free_text"
        user_answer = opt_param.is_a?(Array) ? opt_param.first.to_s : opt_param.to_s
        normalized = user_answer.to_s.downcase.strip
        valid_options = question.options.where(is_correct: true)
        valid_answers = valid_options.pluck(:name).map(&:downcase).map(&:strip)
        if valid_answers.include?(normalized)
          score += question.points
          # find the matching option id so we can persist a QuizAttemptAnswer
          matched = valid_options.find { |o| o.name.to_s.downcase.strip == normalized }
          answers_to_persist[question_id] = matched.present? ? [ matched.id ] : []
        else
          answers_to_persist[question_id] = []
        end
      end
    end

    @quiz_attempt = QuizAttempt.new(user: current_user, quiz: @quiz, score: score)

    if @quiz_attempt.save
      answers_to_persist.each do |question_id, ids|
        Array(ids).each do |oid|
          @quiz_attempt.quiz_attempt_answers.create!(question_id: question_id, option_id: oid)
        end
      end
      redirect_to quiz_completed_path(@quiz, score: score, attempt_id: @quiz_attempt.id), notice: "Quiz completed! You scored #{score} points."
    else
      flash.now[:alert] = "There was an error saving your attempt."
      render "quizzes/completed", status: :unprocessable_entity
    end
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end

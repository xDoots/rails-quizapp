class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[ show edit update destroy ]
  before_action :authorize_resource, only: [ :index ]
  # GET /quizzes or /quizzes.json
  def index
    if current_user.admin?
      @quizzes = Quiz.all
    else
      @quizzes = current_user.quizzes
    end
    authorize @quizzes
  end

  def all_quizzes
    if params[:query].present?
      @quizzes = Quiz.where(public: true)
                     .where("title LIKE ?", "%#{params[:query]}%")
    else
      @quizzes = Quiz.where(public: true)
    end

    respond_to do |format|
      format.turbo_stream { render partial: "quizzes/table", locals: { quizzes: @quizzes } }
      format.html # fallback for normal requests
    end
  end

  def authorize_resource
    authorize Quiz
  end
  # GET /quizzes/1 or /quizzes/1.json
  def show
  end

  # GET /quizzes/new
  def new
    @quiz = Quiz.new
  end

  # GET /quizzes/1/edit
  def edit
    @quiz = Quiz.find(params[:id])
    authorize @quiz
  end

  def completed
    @quiz = Quiz.find(params[:id])
    @quiz_attempt = QuizAttempt.find_by(id: params[:attempt_id]) if params[:attempt_id]
    if @quiz_attempt
      @score = @quiz_attempt.score
      @max_points = @quiz.questions.sum(:points)
    else
      @score = params[:score].to_i
      @max_points = @quiz.questions.sum(:points)
    end
  end

  # POST /quizzes or /quizzes.json
  def create
    # @quiz = Quiz.new(quiz_params)
    @quiz = current_user.quizzes.build(quiz_params)

    respond_to do |format|
      if @quiz.save
        format.html { redirect_to @quiz, notice: "Quiz was successfully created." }
        format.json { render :show, status: :created, location: @quiz }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quizzes/1 or /quizzes/1.json
  def update
    @quiz = Quiz.find(params[:id])
    authorize @quiz

    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to @quiz, notice: "Question was successfully updated." }
        format.json { render :show, status: :ok, location: @quiz }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quizzes/1 or /quizzes/1.json
  def destroy
    @quiz = Quiz.find(params[:id])
    authorize @quiz

    @quiz.quiz_attempts.destroy_all
    @quiz.destroy!

    respond_to do |format|
      format.html { redirect_to quizzes_path, status: :see_other, notice: "Quiz was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def take
    @quiz = Quiz.find(params[:id])
  end

  def take_quiz
    @quiz = Quiz.find(params[:id])
    answers = params[:answers] || {}

    score = 0

    answers.each do |question_id, option_id|
      question = Question.find(question_id)
      selected_option = Option.find(option_id)
      score += question.points if selected_option.is_correct?
    end

    QuizAttempt.create!(
      user: current_user,
      quiz: @quiz,
      score: score
    )

    redirect_to quiz_results_path(@quiz), notice: "You scored #{score} points!"
  end

  def results
    @quiz = Quiz.find(params[:id])
    @quiz_attempts = @quiz.quiz_attempts.order(score: :desc)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def quiz_params
      params.require(:quiz).permit(
        :public,
        :title,
        :description,
        questions_attributes: [
          :id,
          :name,
          :points,
          :_destroy,
          options_attributes: [ :id, :name, :is_correct, :_destroy ]
        ]
      )
    end
end

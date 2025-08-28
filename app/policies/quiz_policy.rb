class QuizPolicy
    attr_reader :user, :quiz

    def initialize(user, quiz)
        @user = user
        @quiz = quiz
    end

    def index?
        @user.present?
    end

    def edit?
        update?
    end

    def update?
        user.admin? || quiz.user == user
    end

    def destroy?
        user.admin? || quiz.user == user
    end
end

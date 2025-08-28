class QuizAttempt < ApplicationRecord
  belongs_to :quiz
  belongs_to :user

  validates :score, presence: true
  has_many :quiz_attempt_answers, dependent: :destroy
  # uncomment if want to let user only 1 attempt per quiz
  # validates :user_id, uniqueness: { scope: :quiz_id, message: "has already attempted this quiz" }
end

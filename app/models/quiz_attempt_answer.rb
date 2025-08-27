class QuizAttemptAnswer < ApplicationRecord
  belongs_to :quiz_attempt
  belongs_to :question
  belongs_to :option
end

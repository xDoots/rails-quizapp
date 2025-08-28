class Option < ApplicationRecord
  belongs_to :question
  has_many :quiz_attempt_answers, dependent: :destroy
end

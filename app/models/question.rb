class Question < ApplicationRecord
  belongs_to :quiz
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true

  has_one_attached :image # if using ActiveStorage

  QUESTION_TYPES = %w[single_choice multiple_choice free_text]

  validates :question_type, inclusion: { in: QUESTION_TYPES }

  before_save :normalize_free_text_answers

  private

  def normalize_free_text_answers
    return unless free_text_answers.is_a?(Array) || free_text_answers.is_a?(String)

    answers = free_text_answers.is_a?(String) ? free_text_answers.split(",") : free_text_answers
    self.free_text_answers = answers.map { |a| a.strip.downcase }.reject(&:blank?)
  end
end

class Quiz < ApplicationRecord
  belongs_to :user
  validates :title, presence: true

  has_many :questions, dependent: :destroy
  has_many :quiz_attempts, dependent: :destroy

  # This is correct for deleting questions
  accepts_nested_attributes_for :questions, allow_destroy: true

  def to_s
    title
  end
end

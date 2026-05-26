class AddQuestionTypeAndFieldsToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :question_type, :string, default: "single_choice"
    add_column :questions, :max_answers, :integer, default: 1
    add_column :questions, :free_text_answers, :text, array: true, default: []
    add_column :questions, :image, :string
  end
end

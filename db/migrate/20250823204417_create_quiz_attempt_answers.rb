class CreateQuizAttemptAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :quiz_attempt_answers do |t|
      t.references :quiz_attempt, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true

      t.timestamps
    end
  end
end

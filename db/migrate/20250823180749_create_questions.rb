class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.string :name
      t.references :quiz, null: false, foreign_key: true
      t.integer :points, null: false, default: 1

      t.timestamps
    end
  end
end

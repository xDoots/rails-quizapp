class CreateOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :options do |t|
      t.string :name
      t.references :question, null: false, foreign_key: true
      t.boolean :is_correct, null: false

      t.timestamps
    end
  end
end

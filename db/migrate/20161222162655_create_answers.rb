class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.text :body
      t.references :question, foreign_key: true, index: true

      t.timestamps
    end
  end
end

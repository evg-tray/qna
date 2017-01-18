class AddUserToAnswers < ActiveRecord::Migration[5.0]
  change_table :answers do |t|
    t.references :user, foreign_key: true, index: true
  end
end

class AddUserToQuestions < ActiveRecord::Migration[5.0]
  change_table :questions do |t|
    t.references :user, foreign_key: true, index: true
  end
end

class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :body, null: false
      t.references :user, foreign_key: true, index: true
      t.integer :commentable_id, null: false
      t.string :commentable_type, null: false
      t.index [:commentable_id, :commentable_type]
      t.timestamps
    end
  end
end

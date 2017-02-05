class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :rating
      t.references :user, foreign_key: true, index: true
      t.integer  :votable_id, null: false
      t.string   :votable_type, null: false
      t.index [:votable_id, :votable_type], unique: true
      t.timestamps
    end
  end
end

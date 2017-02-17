class CreateOmnitokens < ActiveRecord::Migration[5.0]
  def change
    create_table :omnitokens do |t|
      t.references :user, foreign_key: true
      t.references :authorization, foreign_key: true
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end

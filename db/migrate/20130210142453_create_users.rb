class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :oauth_id
      t.string :email
      t.string :name
      t.string :access_token
      t.string :picture

      t.timestamps
    end
  end
end

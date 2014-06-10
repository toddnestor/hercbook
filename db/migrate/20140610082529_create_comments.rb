class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :type
      t.text :content
      t.integer :user_id

      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, :type
  end
end

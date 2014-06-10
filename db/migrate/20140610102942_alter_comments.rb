class AlterComments < ActiveRecord::Migration
  def change
    add_column :comments, :parent_type, :string
    add_index :comments, :parent_type
    remove_column :comments, :type
  end
end

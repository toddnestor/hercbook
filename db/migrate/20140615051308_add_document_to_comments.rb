class AddDocumentToComments < ActiveRecord::Migration
  def change
  end

  add_column :comments, :document_id, :integer
end

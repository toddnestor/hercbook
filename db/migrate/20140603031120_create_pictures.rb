class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :album, index: true
      t.references :user, index: true
      t.string :caption
      t.text :description

      t.timestamps
    end
    add_attachment :pictures, :asset
  end
end

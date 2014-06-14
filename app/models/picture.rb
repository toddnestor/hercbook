class Picture < ActiveRecord::Base
  belongs_to :album
  belongs_to :user
  has_attached_file :asset, styles: {
        original: "1200x1200>", large: "800x800>", medlg: "500x600>", medium: "300x200>", small: "260x180>", mos: "200x135#", thumb: "80x80#"
    }
  
  def to_s
    caption? ? caption : "Picture"
  end
  
  validates_attachment_content_type :asset, :content_type => /\Aimage\/.*\Z/
end

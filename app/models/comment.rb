class Comment < ActiveRecord::Base
	
	belongs_to :user

	validates :content, presence: true,
                  length: {minimum: 1}
end

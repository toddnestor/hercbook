class Comment < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :document

	accepts_nested_attributes_for :document

	validates :content, presence: true,
                  length: {minimum: 1}
end

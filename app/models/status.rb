class Status < ActiveRecord::Base
    
    belongs_to :user
    belongs_to :document
    
    accepts_nested_attributes_for :document

    validates :content, presence: true,
                  length: {minimum: 2}

    validates :user_id, presence: true
    
    self.per_page = 10
  
    def self.for_user(user, options={})
        options[:page] ||=1
        friend_ids = user.friends.map(&:id).push(user.id)
        where("user_id in (?)", friend_ids).
          order("created_at DESC").
          page(options[:page])
    end

end

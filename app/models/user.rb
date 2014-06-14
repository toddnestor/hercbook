class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  require "open-uri"
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :onlinerbytodd

    has_many :statuses
    has_many :comments
    has_many :user_friendships
    has_many :friends, -> { where(user_friendships: { state: "accepted"}) }, through: :user_friendships
    
    has_many :accepted_user_friendships, -> { where(state: 'accepted') }, class_name: 'UserFriendship', foreign_key: :user_id

    has_many :accepted_friends, through: :accepted_user_friendships, source: :friend

    has_many :pending_user_friendships, -> { where(state: 'pending') }, class_name: 'UserFriendship', foreign_key: :user_id

    has_many :pending_friends, through: :pending_user_friendships, source: :friend

    has_many :requested_user_friendships, -> { where(state: 'requested') }, class_name: 'UserFriendship', foreign_key: :user_id

    has_many :requested_friends, through: :requested_user_friendships, source: :friend

    has_many :blocked_user_friendships, -> { where(state: 'blocked') }, class_name: 'UserFriendship', foreign_key: :user_id

    has_many :blocked_friends, through: :blocked_user_friendships, source: :friend

    has_many :been_blocked_user_friendships, -> { where(state: 'been_blocked') }, class_name: 'UserFriendship', foreign_key: :user_id

    has_many :been_blocked_friends, through: :been_blocked_user_friendships, source: :friend

    has_attached_file :avatar, styles: {
        original: "1200x1200>", large: "800x800>", medium: "300x200>", small: "260x180>", thumb: "80x80#"
    }
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

    has_many :albums
    
    has_many :pictures
    
    has_many :activities

    validates :first_name, presence: true

    validates :last_name, presence: true

    validates :profile_name, presence: true,
                             uniqueness: true,
                             format: {
                                 with: /\A[a-zA-Z0-9_-]+\z/,
                                 message: "Must not contain any special characters besides underscore or dash."
                                 }

    def self.get_gravatars
        all.each do |user|
            if !user.avatar?
                user.avatar = URI.parse(user.gravatar_url)
                if user.save
                    print "."
                else
                    print "x"
                end
            end
        end
    end

    def full_name
        first_name + " " + last_name
    end
    
    def to_param
        profile_name
    end

    def gravatar_url
        "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email.strip.downcase)}"
    end
    
    def avatar_image_url
        avatar? ? avatar.url(:thumb) : gravatar_url
    end
    
    def has_blocked?(other_user)
        been_blocked_friends.include?(other_user) || blocked_friends.include?(other_user)
    end
    
    def are_we_friends?(other_user)
        accepted_friends.include?(other_user)
    end
    
    def user_friendship_number(other_user)
        if accepted_friends.include?(other_user) || been_blocked_friends.include?(other_user) || pending_friends.include?(other_user) || requested_friends.include?(other_user)
            other_user.user_friendships.where(friend_id: id).first.id
        end
    end
    
    def have_you_blocked_me?(current_user)
        blocked_friends.include?(current_user)
    end
    
    def create_activity(item, action)
        
            activity = activities.new
            activity.targetable = item
            activity.action = action
        if action != "addedpictures" && action != "updatedpictures"
            activity.save
        else
            @activity = Activity.where("targetable_id = " + item.id.to_s + " AND targetable_type = 'Album'").first
            if @activity
                @activity.updated_at = Time.now
                @activity.action = action
                @activity.save
            else
                activity.save
            end
        end
            activity
        if action == "comment_created"
            @thisType = ""
            case item.parent_type
            when 'status'
                @thisType = "Status"
            when 'album'
                @thisType = "Album"
            when 'picture'
                @thisType = "Picture"
            when 'userfriendship'
                @thisType = "UserFriendship"
            end
            @activity = Activity.where("targetable_id = " + item.parent_id.to_s + " AND targetable_type = '" + @thisType + "'").first
            if @activity
                @activity.updated_at = Time.now
                @activity.save
            else
                activity = activities.new
                case item.parent_type
                when 'status'
                    activity.targetable = Status.where('id = ' + item.parent_id.to_s).first
                when 'album'
                    activity.targetable = Album.where('id = ' + item.parent_id.to_s).first
                when 'picture'
                    activity.targetable = Picture.where('id = ' + item.parent_id.to_s).first
                when 'userfriendship'
                    activity.targetable = UserFriendship.where('id = ' + item.parent_id.to_s).first
                end
                activity.action = 'updated'
                activity.save
            end
        end
    end

    private
end

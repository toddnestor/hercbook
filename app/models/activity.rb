class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :targetable, polymorphic: true
  
  self.per_page = 30
  
  def self.for_user(user, options={})
    options[:page] ||=1
    friend_ids = user.friends.map(&:id).push(user.id)
    active_users = User.all.map(&:id)
    collection = where("user_id in (?) AND targetable_type != ? AND user_id in (?)", friend_ids, 'Comment', active_users).
      order("updated_at DESC")
    if options[:since] && !options[:since].blank?
      since = DateTime.strptime( options[:since], '%s')
      collection = collection.where("updated_at > ? AND user_id in (?)", since, active_users) if since
    end
      collection.page(options[:page])
  end
  
  def self.for_user_notifications(user, options={})
    options[:page] ||=1
    friend_ids = user.friends.map(&:id)
    active_users = User.all.map(&:id)
    collection = where("user_id in (?)", friend_ids).
      order("created_at DESC")
    if options[:since] && !options[:since].blank?
      since = DateTime.strptime( options[:since], '%s')
      collection = collection.where("updated_at > ? AND user_id in (?)", since, active_users) if since
    end
      collection.page(options[:page])
  end
  
  def user_name
    user.full_name
  end
  
  def profile_name
    user.profile_name
  end
  
  def user_avatar
    user.avatar_image_url
  end
  
  def as_json(options={})
    super(
      only: [:action, :id, :targetable_id, :targetable_type, :created_at, :id],
      include: :targetable,
      methods: [:user_name, :profile_name, :user_avatar]
    ).merge(options)
  end
end

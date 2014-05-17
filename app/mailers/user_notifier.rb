class UserNotifier < ActionMailer::Base
  default from: "no-reply@myworldtogo.com"

  def friend_requested(user_friendship_id)
    user_friendship = UserFriendship.find(user_friendship_id)

    @user = user_friendship.user
    @friend = user_friendship.friend

    mail to: @friend.email,
         subject: "#{@user.first_name} wants to be friends on My World to Go"
  end

  def friend_request_accepted(user_friendship_id)
    user_friendship = UserFriendship.find(user_friendship_id)
          
    @user = user_friendship.user
    @friend = user_friendship.friend

    mail to: @friend.email,
         subject: "#{@friend.first_name} has accepted your friendship on My World to Go"
  end
end

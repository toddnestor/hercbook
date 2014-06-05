class ActivitiesController < ApplicationController
  def index
    if signed_in?
      friend_ids = current_user.friends.map(&:id)
      @activities = Activity.where("user_id in (?)", friend_ids.push(current_user.id)).order("created_at DESC").all
    else
      @activities = {};
    end
  end
end

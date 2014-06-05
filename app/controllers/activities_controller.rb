class ActivitiesController < ApplicationController
  def index
    if signed_in?
      params[:page] ||= 1
      @activities = Activity.for_user(current_user, params)
    else
      @activities = {};
    end
  end
end

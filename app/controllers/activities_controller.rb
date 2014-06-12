require 'emoticon_fontify'

class ActivitiesController < ApplicationController
  respond_to :html, :json
  
  def index
    if signed_in?
      params[:page] ||= 1
      respond_to do |format|
        format.html do
          @activities = Activity.for_user(current_user, params)
        end
        format.json do
          @activities = Activity.for_user_notifications(current_user, params)
        end
      end
      @comment = Comment.new
      @status = Status.new
      @status.build_document
      
      respond_with @activities
    else
      @activities = {};
    end
  end
end

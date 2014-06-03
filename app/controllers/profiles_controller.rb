class ProfilesController < ApplicationController
  before_filter :find_user
  before_filter :add_breadcrumbs
  
  def show
    if @user
      @statuses = @user.statuses.order("created_at DESC").all
      render action: :show
    else
      render  file: 'public/404', status: 404, formats: [:html]
    end
  end
  
  private
  def find_user
      @user = User.find_by_profile_name(params[:id])
  end
  
  def add_breadcrumbs
    add_breadcrumb @user.first_name, profile_path(@user)
  end
end

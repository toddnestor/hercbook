class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user
  before_filter :add_breadcrumbs
  
  def show
    if @user
      params[:page] ||= 1
      @activities = Activity.where("user_id = " + @user.id.to_s + " AND targetable_type != 'Comment'" ).order("updated_at DESC").all.page(params[:page])
      @comment = Comment.new
      @status = Status.new
      @status.build_document
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
    add_breadcrumb "Members", members_list_path
    add_breadcrumb @user.first_name, profile_path(@user)
  end
end

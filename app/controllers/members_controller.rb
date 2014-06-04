class MembersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_user_list
  
  def list
  end

  def search
  end
  
  private
  def get_user_list
    @users = User.order("last_name ASC, first_name ASC").all
  end
end

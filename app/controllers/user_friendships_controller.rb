class UserFriendshipsController < ApplicationController
    before_filter :authenticate_user!
    respond_to :html, :json

    def index
      if signed_in?
        @user_friendships = UserFriendshipDecorator.decorate_collection(friendship_association.all)
        respond_with @user_friendships
      end
    end

    def feed
      if signed_in?
        respond_to do |format|
          format.json do

            @user_friendships = UserFriendship.where("user_id = ? AND state = 'requested'", current_user.id)
            if params[:since] && !params[:since].blank?

              

              since = DateTime.strptime( params[:since], '%s')
              @user_friendships = @user_friendships.where("created_at > ?", since) if since
            end

            @user_friendships = @user_friendships.map do |f|
              {
                id: f.id, 
                state: f.state,
                friend_id: [User.where('id = ' + f[:friend_id].to_s).first].map do |u|
                  {
                    first_name: u.first_name,
                    last_name: u.last_name,
                    profile_name: u.profile_name,
                    id: u.id,
                    avatar_file_name: u.avatar_image_url
                  }
                end
              }
            end.flatten
          end
        end
        respond_with @user_friendships
      end
    end

    def show
    end

    def block
        @user_friendship = current_user.user_friendships.find(params[:id])
        if @user_friendship.block!
            flash[:success] = "You have blocked #{@user_friendship.friend.first_name}"
        else
            flash[:error] = "That friendship could not be blocked"
        end

        redirect_to members_list_path
    end

    def new
        if params[:friend_id]
            @friend = User.where(profile_name: params[:friend_id]).first
            raise ActiveRecord::RecordNotFound if @friend.nil?
            @user_friendship = current_user.user_friendships.new(friend: @friend)
        else
            flash[:error] = "Friend required"
        end

        rescue ActiveRecord::RecordNotFound
            render file: 'public/404', status: :not_found
       
    end

    def accept
      @user_friendship = current_user.user_friendships.find(params[:id])
      respond_to do |format|
        if @user_friendship.accept!
          format.html do 
            current_user.create_activity(@user_friendship,'created')
            @user_friendship.friend.create_activity(@user_friendship.mutual_friendship,'created')
            flash[:success] = "You are now friends with #{@user_friendship.friend.first_name}."
            redirect_to user_friendships_path
          end
          format.json do
            current_user.create_activity(@user_friendship,'created')
            @user_friendship.friend.create_activity(@user_friendship.mutual_friendship,'created')
            render json: @user_friendship.to_json
          end
        else
          format.html do
            flash[:error] = "Friend could not be accepted."
            redirect_to user_friendships_path
          end
          format.json { render json: @user_friendship.to_json, status: :precondition_failed }
        end
      end
    end
    
    def create
      if params[:user_friendship] && params[:user_friendship].has_key?(:friend_id)
        @friend = User.where(profile_name: params[:user_friendship][:friend_id]).first
        @user_friendship = UserFriendship.request(current_user, @friend)
        respond_to do |format|
          if @user_friendship.new_record?
            format.html do 
              flash[:error] = "There was problem creating that friend request."
              redirect_to profile_path(@friend)
            end
            format.json { render json: @user_friendship.to_json, status: :precondition_failed }
          else
            format.html do
              flash[:success] = "Friend request sent."
              redirect_to profile_path(@friend)
            end
            format.json { respond_with @user_friendship }
            
          end
        end
      else
        flash[:error] = "Friend required"
        redirect_to root_path
      end
    end

  def edit
    @friend = User.where(profile_name: params[:id]).first
    @user_friendship = current_user.user_friendships.where(friend_id: @friend.id).first.decorate
  end

  def destroy
      @user_friendship = current_user.user_friendships.find(params[:id])
      respond_to do |format|
        if @user_friendship.destroy
          format.html do 
            flash[:success] = "Friendship destroyed."
            redirect_to members_list_path
          end
          format.json do
            render json: @user_friendship.to_json
          end
        else
          format.html do
            flash[:error] = "Friendship could not be desroyed."
            redirect_to members_list_path
          end
          format.json { render status: :precondition_failed }
        end
      end
    end

  private
  def friendship_association
    case params[:list]
      when nil
        current_user.user_friendships
      when 'blocked'
        current_user.blocked_user_friendships
      when 'pending'
        current_user.pending_user_friendships
      when 'requested'
        current_user.requested_user_friendships
      when 'friends'
        current_user.accepted_user_friendships
    end
  end
end

require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
include ActionView::Helpers::DateHelper
    context "#index" do
        context "when not logged in" do
            should "redirect to login page" do
                get :index
                assert_response :redirect
            end
        end

        context "when logged in" do
            setup do
                @friendship1 = create(:pending_user_friendship, user: users(:todd), friend: create(:user, first_name: 'Pending', last_name: 'Friend'))
                @friendship2 = create(:accepted_user_friendship, user: users(:todd), friend: create(:user, first_name: 'Active', last_name: 'Friend'))

                sign_in users(:todd)
                get :index
            end

            should "get the index page without error" do
                assert_response :success
            end

            should "assign some user_friendships" do
                assert assigns(:user_friendships)
            end

            should "display friend's names" do
                assert_match /Pending/, response.body
                assert_match /Active/, response.body
            end

            should "display pending information on a pending friendship" do
                assert_select "#user_friendship_#{@friendship1.id}" do
                    assert_select "em", "Friendship is pending."
                end
            end

            should "display date information on an accepted friendship" do
                assert_select "#user_friendship_#{@friendship2.id}" do
                    assert_select "em", "You have been friends for #{time_ago_in_words(@friendship2.updated_at)}."
                end
            end


        end
    end

    context "#new" do
        context "when not logged in" do
            should "redirect to login page" do
                get :new
                assert_response :redirect
            end
        end

        context "when logged in" do
            setup do
                sign_in users(:todd)
            end

            should "get new and return success" do
                get :new
                assert_response :success
            end

            should "should set a flash error if the friend_id params is missing" do
                get :new, {}
                assert_equal "Friend required", flash[:error]
            end

            should "display the friends name" do
                get :new, friend_id: users(:jason)
                assert_match /#{users(:jason).full_name}/, response.body
            end

            should "assign a new user friendship" do
                get :new, friend_id: users(:jason)
                assert assigns(:user_friendship)
            end

            should "assign a new user friendship to the correct friend" do
                get :new, friend_id: users(:jason)
                assert_equal users(:jason), assigns(:user_friendship).friend
            end

            should "assign a new user friendship to the currently logged in user" do
                get :new, friend_id: users(:jason)
                assert_equal users(:todd), assigns(:user_friendship).user
            end
            
            should "returns a 404 status if no friend is found" do
            get :new, friend_id: 'invalid'
            assert_response :not_found
            end
            
            should "ask if you really want to request this friendship" do
                get :new, friend_id: users(:jason)
                assert_match /Do you really want to add #{users(:jason).full_name} as a friend?/, response.body
            end
        end
    end

    context "#create" do
        context "when not logged in" do
            should "redirect to login page" do
                get :new
                assert_response :redirect
                assert_redirected_to login_path
            end
        end
        
        context "when logged in" do
            setup do
                sign_in users(:todd)
            end

            context "with no friend id" do
                setup do
                    post :create
                end

                should "set the flash error message" do
                    assert !flash[:error].empty?
                end

                should "redirect to the site root" do
                    assert_redirected_to root_path
                end
            end

            context "successfully" do
                should "create two user friendship objects" do
                    assert_difference 'UserFriendship.count', 2 do
                        post :create, user_friendship: { friend_id: users(:jim).profile_name }
                    end
                end
            end

            context "with a valid friend id" do
                setup do
                    post:create, user_friendship: { friend_id: users(:jason) }
                end

                should "assign a friend object" do
                    assert assigns(:friend)
                    assert_equal users(:jason), assigns(:friend)
                end

                should "assign a user friendship object" do
                    assert assigns(:user_friendship)
                    assert_equal users(:todd), assigns(:user_friendship).user
                    assert_equal users(:jason), assigns(:user_friendship).friend
                end

                should "create a friendship" do
                    assert users(:todd).pending_friends.include?(users(:jason))
                end

                should "redirect to the friend's profile" do
                    assert_response :redirect
                    assert_redirected_to profile_path(users(:jason))
                end

                should "set the flash success message" do
                    assert flash[:success]
                    assert_equal "Friend request sent.", flash[:success]
                end
            end
        end
    end

    context "#accept" do
        context "when not logged in" do
            should "redirect to the login page" do
                put :accept, id: 1
                assert_response :redirect
                assert_redirected_to login_path
            end
        end

        context "when logged in" do
            setup do
                @friend = create(:user)
                @user_friendship = create(:pending_user_friendship, user: users(:todd), friend: @friend)
                create(:pending_user_friendship, friend: users(:todd), user: @friend)
                sign_in users(:todd)
                put :accept, id: @user_friendship
                @user_friendship.reload
            end

            should "assign a user friendship" do
                assert assigns(:user_friendship)
                assert_equal @user_friendship, assigns(:user_friendship)
            end

            should "update the state to accepted" do
                assert_equal 'accepted', @user_friendship.state
            end

            should "have a flash success message" do
                assert_equal "You are now friends with #{@user_friendship.friend.first_name}.", flash[:success]
            end
        end
    end

    context "#edit" do
        context "when logged in" do
            should "redirect to the login page" do
                get :edit, id: 1
                assert_response :redirect
                assert_redirected_to login_path
            end
        end

        context "when logged in" do
            setup do
                @user_friendship = create(:pending_user_friendship, user: users(:todd))
                sign_in users(:todd)
                get :edit, id: @user_friendship.friend.profile_name
            end

            should "get edit and return success" do
                assert_response :success
            end

            should "assign to user_friendship" do
                assert assigns(:user_friendship)
            end

            should "assign to friend" do
                assert assigns(:friend)
            end
        end
    end

    context "#destroy" do
        context "when not logged in" do
            should "redirect to the login page" do
                delete :destroy, id: 1
                assert_response :redirect
                assert_redirected_to login_path
            end
        end
        
        context "when logged in" do
            setup do
                @friend = create(:user)
                @user_friendship = create(:accepted_user_friendship, friend: @friend, user: users(:todd))
                create(:accepted_user_friendship, friend: users(:todd), user: @friend)

                sign_in users(:todd)
            end
            
            should "delete user friendships" do
                assert_difference 'UserFriendship.count', -2 do
                    delete :destroy, id: @user_friendship
                end
            end

            should "set the flash" do
                delete :destroy, id: @user_friendship
                assert_equal 'Friendship destroyed.', flash[:success]
            end
        end
    end
end

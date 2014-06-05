require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "should not display a blocked user's posts when logged in" do
    sign_in users(:jason)
    users(:blocked_friend).statuses.create(content: 'Blocked statushere')
    users(:jim).statuses.create(content: 'Non-blocked status')
    get :index
    assert_match (/Non\-blocked status/), (response.body)
    assert_no_match (/Blocked\ statushere/), (response.body)
  end

  test "should get new" do
    sign_in users(:jason)
    get :new
    assert_response :success
  end

  test "should create status when logged in" do
    sign_in users(:jason)
    assert_difference('Status.count') do
      post :create, status: { content: @status.content, user_id: @status.user.full_name }
    end

    assert_redirected_to status_path(assigns(:status))
  end
  
  test "should create an activity item for the status when logged in" do
    sign_in users(:jason)
    assert_difference('Activity.count') do
      post :create, status: { content: @status.content, user_id: @status.user.full_name }
    end
  end

  test "should create status for the current user when logged in" do
    sign_in users(:jason)
    
    assert_difference('Status.count') do
      post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:jason).id
  end

  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

  test "should get edit when logged in" do
    sign_in users(:jason)
    get :edit, id: @status
    assert_response :success
  end

  test "should redirect status update when not logged in" do
    put :update, id: @status, status: { content: @status.content }
    assert_response :redirect
  end

  test "should update status when logged in" do
    sign_in users(:jason)
    put :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
  end
  
  test "should create an activity item when status is updated and user is logged in" do
    sign_in users(:jason)
    assert_difference 'Activity.count' do
      put :update, id: @status, status: { content: @status.content }
    end
  end

  test "should update a status for the current user when logged in" do
    sign_in users(:jason)
    put :update, id: @status, status: { content: @status.content }
    assert_response :redirect
    assert_equal assigns(:status).user_id, users(:jason).id
  end

  test "should not update a status if nothing has changed" do
    sign_in users(:jason)
    put :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:jason).id
  end

  test "should destroy status" do
    sign_in users(:jason)
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
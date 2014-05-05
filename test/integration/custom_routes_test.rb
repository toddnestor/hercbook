require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
    test "that the /login route opens the login page" do
        get '/login'
        assert_response :success
    end
    
    test "that the /logout route logs out the user" do
        get '/logout'
        assert_response :redirect
        assert_redirected_to '/'
    end

    test "that the /register route opens the register page" do
        get '/register'
        assert_response :success
    end

    test "that the /feed route opens the status page" do
        get '/feed'
        assert_response :success
    end

    test "that the /feed/create route opens the new status page" do
        get '/feed/create'
        assert_response :success
    end


end

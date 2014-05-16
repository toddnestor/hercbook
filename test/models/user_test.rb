require 'test_helper'

class UserTest < ActiveSupport::TestCase
    should have_many :user_friendships
    should have_many :friends

test "a user should enter a first name" do

    user = User.new
    assert !user.save
    assert !user.errors[:first_name].empty?
    end

test "a user should enter a last name" do
    user = User.new
    assert !user.save
    assert !user.errors[:last_name].empty?
    end

test "a user should enter a profile name" do
    user = User.new
    assert !user.save
    assert !user.errors[:profile_name].empty?
    end

test "a user should have a unique profile name" do
    user = User.new
    user.profile_name = users(:todd).profile_name
    assert !user.save
    assert !user.errors[:profile_name].empty?
    end

test "a user's profile name should have no spaces" do
    user = User.new(first_name: 'Todd', last_name: 'Nestor', email: 'todd.nestor2@gmail.com')
    user.password = user.password_confirmation = 'asdfasdf'

    user.profile_name = "spaces are in here"
    assert !user.save
    assert !user.errors[:profile_name].empty?
    assert user.errors[:profile_name].include?("Must not contain any special characters besides underscore or dash.")
    end

test "a user can have a correctly formatted profile name" do
        user = User.new(first_name: 'Todd', last_name: 'Nestor', email: 'todd.nestor2@gmail.com')
        user.password = user.password_confirmation = 'asdfasdf'

        user.profile_name = 'toddnestor'
        assert user.valid?
    end

test "that no error is raised when trying to access a friend list" do
        assert_nothing_raised do
            users(:todd).friends
        end
    end

test "that creating friends on a user works" do
    users(:todd).pending_friends << users(:jim)
    users(:todd).pending_friends.reload
    assert users(:todd).pending_friends.include?(users(:jim))
end

test "that calling to_param on a user returns the profile_name" do
    assert_equal "todd", users(:todd).to_param
end

end

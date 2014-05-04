require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
    user = User.new
    user.profile_name = "spaces are in here"
    assert !user.save
    assert !user.errors[:profile_name].empty?
    assert user.errors[:profile_name].include?("Must not contain any special characters besides underscore or dash.")
    end

end

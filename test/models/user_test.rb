require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = users(:andy)
  end

  ##### Authentication ####
  test "authenticate valid password user not nil" do
    assert !!@user.authenticate("pwd")
  end

  test "authenticate invalid password user nil" do
    assert !@user.authenticate("asdf")
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

  #### Other tests here ####


end

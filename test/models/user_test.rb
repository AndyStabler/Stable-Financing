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

  #### Other tests here ####
end

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = users(:andy)
  end

  ##### Login ####

  test "authenticate valid username and valid password user not nil" do
  	username = "andystabler"
  	password = "pwd"
  	assert !User.authenticate(username, password).nil?
  end

  test "authenticate invalid user and password exists user nil" do
  	username = "aabler"
  	password = "pwd"
  	assert User.authenticate(username, password).nil?
  end

  test "authenticate invalid user and password does not exist user nil" do
  	username = "andysasdfsdtabler"
  	password = "pasdfwd"
  	assert User.authenticate(username, password).nil?
  end

  test "authenticate valid user and password does not exist user nil" do
  	username = "andystabler"
  	password = "padfwd"
  	assert User.authenticate(username, password).nil?
  end

  #### Other tests here ####
end

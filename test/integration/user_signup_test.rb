require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, :user => { :name =>  "Andy jh",
        :email => "asd@sdf.sd.fd",
        :email_confirmation => "asd@sdf.sd.fd",
        :password =>  "a"*6,
        :password_confirmation => "a"*6 }
      end
    assert_template 'users/show'
    assert is_logged_in?
  end

  test "invalid signup blank password" do
    get signup_path
    assert_no_difference 'User.count' do
      post_via_redirect users_path, :user => { :name =>  "Andy jh",
        :email => "asd@sdf.sd.fd",
        :email_confirmation => "asd@sdf.sd.fd",
        :password =>  " "*6,
        :password_confirmation => " "*6 }
      end
    assert_template :new
    assert !is_logged_in?
  end

  test "invalid signup erroneous email" do
    get signup_path
    assert_no_difference 'User.count' do
      post_via_redirect users_path, :user => { :name =>  "Andy jh",
        :email => "asdsdf.sd.fd",
        :email_confirmation => "asdsdf.sd.fd",
        :password =>  "a"*6,
        :password_confirmation => "a"*6 }
      end
    assert_template :new
    assert !is_logged_in?
  end

  test "invalid signup email exists" do
    get signup_path
    assert_no_difference 'User.count' do
      post_via_redirect users_path, :user => { :name =>  "Andy jh",
        :email => "andystabler@hotmail.co.uk",
        :email_confirmation => "andystabler@hotmail.co.uk",
        :password =>  "a"*6,
        :password_confirmation => "a"*6 }
      end
    assert_template :new
    assert !is_logged_in?
  end

  test "invalid signup email missing" do
    get signup_path
    assert_no_difference 'User.count' do
      post_via_redirect users_path, :user => { :name =>  "Andy jh",
        :password =>  "a"*6,
        :password_confirmation => "a"*6 }
      end
    assert_template :new
    assert !is_logged_in?
  end
end

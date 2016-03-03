require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:andy)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_equal User.all.map(&:email), assigns(:users).map(&:email)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {name: "Homer Simpson", password: "doughnuts", email: "h.simpson@aol.com"}
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: {name: "Homer Simpson", password: "doughnuts", email: "h.simpson@aol.com"}
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end

  #   test "should create transfer" do
  #   assert_difference('Transfer.count') do
  #     post :create, transfer: { amount: @transfer.amount, daily: @transfer.daily, dat: @transfer.dat, monthly: @transfer.monthly, recurring: @transfer.recurring, user_id: @transfer.user_id, weekly: @transfer.weekly }
  #   end

  #   assert_redirected_to transfer_path(assigns(:transfer))
  # end
end

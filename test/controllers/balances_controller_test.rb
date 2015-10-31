require 'test_helper'

class BalancesControllerTest < ActionController::TestCase
  setup do
    @balance = balances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:balances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create balance" do
    assert_difference('Balance.count') do
      post :create, balance: { value: 50.50, :on => Time.now, :user_id => users(:andy).id }
    end

    assert_redirected_to balance_path(assigns(:balance))
  end

  test "should show balance" do
    get :show, id: @balance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @balance
    assert_response :success
  end

  test "should update balance" do
    patch :update, id: @balance, balance: { on: Time.now, value: @balance.value }
    assert_redirected_to balance_path(assigns(:balance))
  end

  test "should destroy balance" do
    assert_difference('Balance.count', -1) do
      delete :destroy, id: @balance
    end

    assert_redirected_to balances_path
  end
end

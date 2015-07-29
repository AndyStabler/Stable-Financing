require 'test_helper'

class TransactionsControllerTest < ActionController::TestCase
  setup do
    @transfer = transactions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:Transfers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transaction" do
    assert_difference('Transfer.count') do
      post :create, transaction: { amount: @transfer.amount, daily: @transfer.daily, dat: @transfer.dat, monthly: @transfer.monthly, recurring: @transfer.recurring, user_id: @transfer.user_id, weekly: @transfer.weekly }
    end

    assert_redirected_to transaction_path(assigns(:transaction))
  end

  test "should show transaction" do
    get :show, id: @transfer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transfer
    assert_response :success
  end

  test "should update transaction" do
    patch :update, id: @transfer, transaction: { amount: @transfer.amount, daily: @transfer.daily, dat: @transfer.dat, monthly: @transfer.monthly, recurring: @transfer.recurring, user_id: @transfer.user_id, weekly: @transfer.weekly }
    assert_redirected_to transaction_path(assigns(:@transfer))
  end

  test "should destroy transaction" do
    assert_difference('Transfer.count', -1) do
      delete :destroy, id: @transfer
    end

    assert_redirected_to transactions_path
  end
end

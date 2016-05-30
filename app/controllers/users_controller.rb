class UsersController < ApplicationController
  before_action :set_user, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :new_balance,
    :new_transfer,
    :transfers
  ]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @balance = @user.balance
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @user.balance_data }
      format.csv do
        response.headers['Content-Disposition'] = "attachment; filename=balance_data.csv"
      end
    end
  end

  # GET /users/1/transfers.json
  def transfers
    transfer_date = params[:transfer]
    if (transfer_date)
      transfer_date = Date.parse(transfer_date) || Date.current
      transfers = @user.transfer_calculator.transfers_occurring_on(transfer_date)
    else
      transfers = @user.transfers
    end
    render json: transfers.as_json(methods: :recurrence)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #POST /users/:id/new/transfer
  def new_transfer
    @transfer = Transfer.new(trans_params)
    @transfer.user= @user
    respond_to do |format|
      if @transfer.save
        format.html { redirect_to action: :show }
        format.json { render json: :no_content }
      else
        format.html { render :show }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  #POST /users/:id/new/balance
  def new_balance
    @balance = Balance.new({ :user => @user, :on => Time.zone.now }.merge balance_params)
    @balance.save
    render :partial => "new_balance.js.coffee"
  end

  private

  def set_user
    not_found unless current_user.id.to_s == params[:id].to_s
    @user = current_user
  end

  def trans_params
    params.require(:transfer).permit(:on, :amount, :recurrence, :user_id, :outgoing, :reference)
  end

  def balance_params
    params.require(:balance).permit(:value)
  end

  def user_params
    params.require(:user).permit(:name, :password, :password, :password_confirmation, :email, :email_confirmation)
  end
end

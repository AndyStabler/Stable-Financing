class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :new_transfer, :update_balance]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @balance = Balance.new
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @user.balance_data }
      format.csv do
        response.headers['Content-Disposition'] = "attachment; filename=balance_data.csv"
      end
    end
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

  def update_balance
    @balance = Balance.new(balance_params)
    @balance.user= @user
    @balance.on = Time.zone.now
    respond_to do |format|
      if @balance.save
        format.html { redirect_to action: :show }
        format.json { render json: :no_content }
      else
        format.html { render :show }
        format.json { render json: @balance.errors, status: :unprocessable_entity }
      end

    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    not_found unless current_user.id.to_s == params[:id].to_s
    @user = current_user
  end

  # TODO: this is the exact same function as is in the transaction controller. Make less DRY . . .
  def trans_params
    params.require(:transfer).permit(:on, :amount, :recurrence, :user_id, :outgoing, :reference)
  end

  def balance_params
    params.require(:balance).permit(:value)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :password, :password, :password_confirmation, :email, :email_confirmation)
  end
end

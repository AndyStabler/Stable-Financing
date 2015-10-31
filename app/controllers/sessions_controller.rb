class SessionsController < ApplicationController

  def new
  	
  end

  def  create
  	user = User.authenticate(params[:session][:username], params[:session][:password])
  	if user
  		# log user in
  		# render user page
      log_in user
      redirect_to user
  	else
  		# set error message
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy

  end
end

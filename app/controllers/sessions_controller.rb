class SessionsController < ApplicationController

  def new
  	
  end

  def  create
    login_name = params[:session][:username]
    user = User.find_by(:email => login_name.try(:downcase)) || User.find_by(:username => login_name)
  	if user && user.authenticate(params[:session][:password])
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
    log_out
    redirect_to root_url
  end
end

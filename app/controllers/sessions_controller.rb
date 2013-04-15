class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination"
      render 'new'
    else
      session[:remember_token] = user.id #this stores the id of the user logged in the session
      redirect_to :controller => 'passwords', :action => 'index'
    end
  end
  
  def destroy
    session[:remember_token] = nil
    flash[:notice] = "You have successfully logged out."
    redirect_to root_path
  end
end

class SessionsController < ApplicationController

  def authorize
  end
  
  def new
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination"
      render 'new'
    else
      session[:remember_token] = user.id #this stores the id of the user logged in the session
      redirect_to :controller => 'encpasswords', :action => 'index'
    end
  end
  
  def destroy
    session[:remember_token] = nil
    session[:user] = nil
    flash[:notice] = "You have successfully signed out."
    #redirect_to '/signin'
    redirect_to root_path #takes you to root specified in routes.db
  end
  
  
  %%
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end


%
end

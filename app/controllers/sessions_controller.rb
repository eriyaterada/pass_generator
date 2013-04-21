class SessionsController < ApplicationController
  
  def authorize
  end
  
  def new
    # if the user is alreay logged in, redirects the user from this
    # sign_in page to their home page
    if session[:remember_token]
      redirect_to :controller => 'encpasswords', :action => 'index'
    end
  end

  def create
    # a session's expiration time is set to 10 minutes into the future upon creating a new session
    session[:expire_time] = 10.minutes.since
    
    # validate the user
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination" # the matching user did not exist
      render 'new'
    else
      session[:remember_token] = user.id #this stores the id of the user logged in the session
      redirect_to :controller => 'encpasswords', :action => 'index'
    end
  end
  
  def destroy
    session[:remember_token] = nil
    session[:user] = nil
    
    # if the expiration time is old, display that the session has timed out
    if session[:expire_time] < Time.now
      flash[:error] = "Your session has timed out."
    # otherwise, the user logged out voluntarily -- display that the user has successfully signed out
    else
      flash[:notice] = "You have successfully signed out."
    end
    redirect_to '/signin'
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

class SessionsController < ApplicationController
  
  def authorize
  end
  
  # this method if the user is alreay logged in, redirects the user from this
  # sign_in page to their home page
  def new
 
    if session[:remember_token]
      redirect_to :controller => 'encpasswords', :action => 'index'
    end
  end
  # this methods creates a new session and sets the session[:expire_time]
  # :arg: session[:expire_time] => Time
  # :arg: params[:session][:email] => string
  # :arg: params[:session][:password] => string
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
  #this method destroy a session and redirect the user to the sign in page
  # :arg: session[:remember_token] => string
  # :arg: session[:user] => User
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
  
  
  
end

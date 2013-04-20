class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  helper_method :current_user
  
  private  
  def current_user  
    @current_user ||= User.find(session[:remember_token]) if session[:remember_token]  
  end 
end

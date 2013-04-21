class UsersController < ApplicationController

  skip_before_filter :authorize, :only => [:new, :create]
  
# this method shows all user's information

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json =>  @users }
    end
  end
# this method shows the selected User's information
# params[:id] => integer
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json =>  @user }
    end
  end

# this method creates a new user
# return => User
  def new
    @user = User.new
  end
  
# this method gets the selected user
# return => User
  def edit
    @user = User.find(params[:id])
  end
  
#this method creates a new User object with the parameters entered in the form
# return => nil
  def create
  @user = User.new(params[:user]) 
  
  if (@user.save)
    @display_message = flash[:success] = 'Your account has been successfully created. You may now login.'
    redirect_to :controller => 'sessions', :action => 'new'
  else
    render 'new'
  end
  
  end
  
  #this method update's the selected user's information by using the information in the form
  #return => nil
  
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json =>  @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # this method deletes a selected user
  # params[:id] => integer
  # return => nil
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
  
  
end

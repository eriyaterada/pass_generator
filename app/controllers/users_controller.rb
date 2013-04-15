class UsersController < ApplicationController

  skip_before_filter :authorize, :only => [:new, :create]
  

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json =>  @users }
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json =>  @user }
    end
  end


  def new
    @user = User.new
  end
  
  
  def edit
    @user = User.find(params[:id])
  end
  

  def create
  @user = User.new(params[:user]) #this creates a new User object with the parameters entered in the form
  
  if (@user.save)
    @display_message = flash[:notice] = 'Your account has been successfully created. You may now login.'
    redirect_to :controller => 'sessions', :action => 'new'
  else
    render 'new'
  end
  
  end
  
  
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
  
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
  
  
end

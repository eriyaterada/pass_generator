class EncpasswordsController < ApplicationController
  before_filter :authorize, :check_session
  #this ensures that the user has to be logged-in to visit all the webpages
  #this also ensures that when a new page is loaded, the system always check the session status
  
  #this authenticate the user is logged in correctly
  def authorize
      unless User.find_by_id(session[:remember_token])
        flash[:notice] = "Please login"
        redirect_to :controller => 'sessions', :action => 'new'
    end
  end
  
  #this method checks the session's status
  # session[:expire_time] => Time
  # return => nil
  def check_session
    # if a session's expiration time it is old, sign the user out by force
    if session[:expire_time] < Time.now
      redirect_to '/signout'
    else
    # otherwise, reset the session's expiration time to 10 minutes into the future
      session[:expire_time] = 10.minutes.since
    end
  end
  
  # GET /encpasswords
  # GET /encpasswords.json
  # this method shows user's all encpasswords in a list
  def index
    @encpasswords = current_user.encpasswords.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @encpasswords }
    end
    
  end

  # GET /encpasswords/1
  # GET /encpasswords/1.json
  # this method shows a user's encpassword in a list but the user can only view its own information
  # params[:id]
  # return => nil
  def show
    if current_user.encpasswords.find_by_id(params[:id])
    
    @encpassword = Encpassword.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @encpassword }
    end
    else
       flash[:notice] = "YOU DO NOT HAVE THE RIGHTS TO VIEW THIS PAGE"
      redirect_to :controller => 'encpasswords', :action => 'index'
    end
  end

  # GET /encpasswords/new
  # GET /encpasswords/new.json
  # this method generates the form to create the new encpassword object
  def new
    @encpassword = Encpassword.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @encpassword }
    end
  end

  # GET /encpasswords/1/edit
  # this method gets the selected encpassword object
  # return Encpassword
  # params[:id] => integer
  def edit
    @encpassword = Encpassword.find(params[:id])
  end

  # POST /encpasswords
  # POST /encpasswords.json
  # this method creates a new encpassword object
  # session[:remember_token] => string
  # params[:encpassword][:master_password] => string
  def create
    @encpassword  = current_user.encpasswords.build(params[:encpassword])
    
    user = User.authenticate(User.find(session[:remember_token]).email, params[:encpassword][:master_password])
    if user.nil?
      flash.now[:error] = "Master password is incorrect"
      render 'new'
      
      
    else
    respond_to do |format|
      if @encpassword.save
        format.html { redirect_to "/encpasswords", notice: 'Encpassword was successfully created.' }
        format.json { render json: @encpassword, status: :created, location: @encpassword }
      else
        format.html { render action: "new" }
        format.json { render json: @encpassword.errors, status: :unprocessable_entity }
      end
    end
    
    end
  end

  # PUT /encpasswords/1
  # PUT /encpasswords/1.json
  # this method updates the attributes of a selected encpassword object 
  # return nil
  # params[:id] => integer
  # params[:encpassword] => string
  def update
    @encpassword = Encpassword.find(params[:id])

    respond_to do |format|
      if @encpassword.update_attributes(params[:encpassword])
        format.html { redirect_to "/encpasswords", notice: 'Your password for ' + @encpassword.service + ' was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @encpassword.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /encpasswords/1
  # DELETE /encpasswords/1.json
  # this delete a selected encpassword object
  # return => nil
  # params[:id] => integer
  def destroy
    @encpassword = Encpassword.find(params[:id])
    @encpassword.destroy

    respond_to do |format|
      format.html { redirect_to encpasswords_url }
      format.json { head :no_content }
    end
  end
  
  #this method enables the user to decrypt an ecnrypted password which belonging to a selected service
  #return => string
  #session[:remember_token] => string
  #params[:Master_password] => string
  #params[:service] => string
  def decrypt
      user = User.authenticate(User.find(session[:remember_token]).email, params[:Master_Password])
      if user.nil?
        
        redirect_to :controller => 'encpasswords', :action => 'index'
      flash[:error] = "Master password is incorrect"
      
    else
      @decrypted_password = Encpassword.decrypt(params[:service],params[:Master_Password])
    end
  end
  

  #this method return the current user
  #return => User
  #session[:remember_token] => string
  def current_user
    @current_user = User.find_by_id(session[:remember_token])
  end
 
  # this methods enable to keep track of the current loggin user
  # return => nil
  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end
   
   # a helper method
   # return => nil
  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
end

class EncpasswordsController < ApplicationController
  before_filter :authorize
  
  def authorize
    unless User.find_by_id(session[:remember_token])
      flash[:notice] = "Please login"
      redirect_to :controller => 'sessions', :action => 'new'
    end
  end
  
  # GET /encpasswords
  # GET /encpasswords.json
  def index
    @encpasswords = current_user.encpasswords.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @encpasswords }
    end
  end

  # GET /encpasswords/1
  # GET /encpasswords/1.json
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
  def new
    @encpassword = Encpassword.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @encpassword }
    end
  end

  # GET /encpasswords/1/edit
  def edit
    @encpassword = Encpassword.find(params[:id])
  end

  # POST /encpasswords
  # POST /encpasswords.json
  def create
    @encpassword  = current_user.encpasswords.build(params[:encpassword])
    
    user = User.authenticate(User.find(session[:remember_token]).email, params[:encpassword][:master_password])
    if user.nil?
      flash.now[:error] = "Master password is incorrect"
      render 'new'
      
      
    else
    respond_to do |format|
      if @encpassword.save
        format.html { redirect_to @encpassword, notice: 'Encpassword was successfully created.' }
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
  def update
    @encpassword = Encpassword.find(params[:id])

    respond_to do |format|
      if @encpassword.update_attributes(params[:encpassword])
        format.html { redirect_to @encpassword, notice: 'Encpassword was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @encpassword.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /encpasswords/1
  # DELETE /encpasswords/1.json
  def destroy
    @encpassword = Encpassword.find(params[:id])
    @encpassword.destroy

    respond_to do |format|
      format.html { redirect_to encpasswords_url }
      format.json { head :no_content }
    end
  end
  def decrypt
    decrypted_password = Encpassword.decrypt(params[:service],params[:master_password])
  end
  def current_user
    @current_user = User.find_by_id(session[:remember_token])
  end
  
  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end
    
  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
end

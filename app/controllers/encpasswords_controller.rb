class EncpasswordsController < ApplicationController
  # GET /encpasswords
  # GET /encpasswords.json
  def index
    @encpasswords = Encpassword.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @encpasswords }
    end
  end

  # GET /encpasswords/1
  # GET /encpasswords/1.json
  def show
    @encpassword = Encpassword.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @encpassword }
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
    @encpassword = Encpassword.new(params[:encpassword])

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
end

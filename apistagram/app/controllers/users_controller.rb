class UsersController < ApplicationController

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @iphotos }
    end
  end

  def show
    @iphoto = Iphoto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @iphoto }
    end
  end

  def new
    @iphoto = Iphoto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @iphoto }
    end
  end

  def edit
    @iphoto = Iphoto.find(params[:id])
  end

  def create
    @iphoto = Iphoto.new(params[:iphoto])

    respond_to do |format|
      if @iphoto.save
        format.html { redirect_to @iphoto, notice: 'Iphoto was successfully created.' }
        format.json { render json: @iphoto, status: :created, location: @iphoto }
      else
        format.html { render action: "new" }
        format.json { render json: @iphoto.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @iphoto = Iphoto.find(params[:id])

    respond_to do |format|
      if @iphoto.update_attributes(params[:iphoto])
        format.html { redirect_to @iphoto, notice: 'Iphoto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @iphoto.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @iphoto = Iphoto.find(params[:id])
    @iphoto.destroy

    respond_to do |format|
      format.html { redirect_to iphotos_url }
      format.json { head :no_content }
    end
  end
end

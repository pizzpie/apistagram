class IphotosController < ApplicationController
  # GET /iphotos
  # GET /iphotos.json
  def index
    @iphotos = Iphoto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @iphotos }
    end
  end

  # GET /iphotos/1
  # GET /iphotos/1.json
  def show
    @iphoto = Iphoto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @iphoto }
    end
  end

  # GET /iphotos/new
  # GET /iphotos/new.json
  def new
    @iphoto = Iphoto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @iphoto }
    end
  end

  # GET /iphotos/1/edit
  def edit
    @iphoto = Iphoto.find(params[:id])
  end

  # POST /iphotos
  # POST /iphotos.json
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

  # PUT /iphotos/1
  # PUT /iphotos/1.json
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

  # DELETE /iphotos/1
  # DELETE /iphotos/1.json
  def destroy
    @iphoto = Iphoto.find(params[:id])
    @iphoto.destroy

    respond_to do |format|
      format.html { redirect_to iphotos_url }
      format.json { head :no_content }
    end
  end

  def favorite
    @iphoto = Iphoto.find(params[:id])
    favorite = @iphoto.favorites.find_by_user_id(current_user.id)

    if favorite 
      favorite.destroy
    else
      @iphoto.favorites.create(:user_id => current_user.id)
    end

    respond_to do |format|
      format.html { redirect_to iphotos_url }
      format.json { head :no_content }
      format.js {}
    end
  end

  def add_comment
    @iphoto = Iphoto.find(params[:id])
    @user_who_commented = current_user
    if current_user 
      @comment = Comment.build_from( @iphoto, @user_who_commented.id, params[:comment])
      @comment.save
      redirect_to iphoto_url(@iphoto)
    else
      redirect_to '/auth/instagram'
    end
  end
end

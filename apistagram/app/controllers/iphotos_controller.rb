class IphotosController < ApplicationController

  def index
    @iphotos = Iphoto.all
  end

  def show
    @ads = AppConfiguration['ads']['iphoto_page']
    @iphoto = Iphoto.find(params[:id])
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

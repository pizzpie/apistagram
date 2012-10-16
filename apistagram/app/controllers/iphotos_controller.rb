require 'will_paginate/array'
class IphotosController < ApplicationController

  def index
    if params[:category]
      @category = params[:category]
      @sort     = params[:sort]
      @iphotos  = Iphoto.fetch_index_listing(params[:category], params[:sort]).paginate(:page => params[:page], :per_page => 21)
    else
      @iphotos  = Iphoto.listed.limit(6).order('created_at desc')
      @newest, @hottest, @popular = Iphoto.fetch_index_listing
    end
  end

  def show
    @ads = AppConfiguration['ads']['iphoto_page']
    @iphoto = Iphoto.listed.where("id = ? or public_id = ?", params[:id], params[:id]).first
    if @iphoto
      @recent_photos = Iphoto.listed.where("username = ? and id != ?", @iphoto.username, @iphoto.id).limit(6)
    else
      redirect_to iphotos_url
    end
  end

  def destroy
    @iphoto = Iphoto.find_by_id(params[:id])
    if current_user and current_user.is_admin? || current_user.name == @iphoto.username 
      @iphoto.destroy 
      redirect_to iphotos_url, :notice => "Photo removed successfully!"
    else
      redirect_to iphoto_url, :notice =>  "You do not have access to this photo edit permissions."
    end
  end

  def favorite
    @size = params[:size]
    @iphoto = Iphoto.find(params[:id])
    favorite = @iphoto.favorites.find_by_user_id(current_user.id)

    if favorite 
      favorite.destroy
    else
      @iphoto.favorites.create(:user_id => current_user.id)
    end

    respond_to do |format|
      format.html { redirect_to iphoto_url(@iphoto) }
      format.json { head :no_content }
      format.js {}
    end
  end

  def add_comment
    @iphoto = Iphoto.find(params[:id])
    @user_who_commented = current_user
    if current_user 
      @comment = Comment.build_from( @iphoto, @user_who_commented.id, params[:comment])
      if @comment.save
        return render 'add_comment.js.erb'
      else
        return render :nothing => true
      end
    else
      redirect_to login_url
    end
  end

  def remove_comment
    @iphoto = Iphoto.find(params[:id])
    @comment = @iphoto.comment_threads.find_by_id(params[:comment_id])
    if @comment and current_user.name == @iphoto.username || current_user == @comment.user
      @comment.destroy
      return render 'remove_comment.js.erb'
    else
      return render :nothing => true
    end
  end
end

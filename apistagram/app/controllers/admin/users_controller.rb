class Admin::UsersController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin_user

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { redirect_to admin_users_url }
      format.js
    end
  end

  def fetch_photos
    if current_user.get_grams
      redirect_to admin_users_url, :notice => "Photo fetcher added to the queue. Photos will be processed and added to the system soon!"
    end
  end
end

class UsersController < ApplicationController

  before_filter :find_user

  def show
    @ad = AppConfiguration['ads']['user_profile_page']['left_section']
    @iphotos = Iphoto.where(:username => params[:id]).paginate(:page => params[:page], :per_page => 1) #right now displaying favorites, will change to photos later
  end

  # payal says: commented the other actions as currently only view profile action is required.
  # def index
  #   @users = User.all
  # end

  # def edit
  #   @user = User.find(params[:id])
  # end

  # def update
  #   @user = User.find(params[:id])

  #   if @user.update_attributes(params[:user])
  #     redirect_to @user, notice: 'User was successfully updated.'
  #   else
  #     render action: "edit"
  #   end
  # end

  # def destroy
  #   @user = User.find(params[:id])
  #   @user.destroy

  #   redirect_to users_url
  # end

  private
    def find_user
      @user = User.where("id = ? or name = ?", params[:id], params[:id]).first
      unless @user
        @user = params[:id]
      end

      redirect_to iphotos_url unless @user
    end
end

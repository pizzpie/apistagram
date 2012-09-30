class UsersController < ApplicationController

  def show
    @user = User.find_by_name(params[:id])
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
end

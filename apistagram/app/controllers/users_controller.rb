class UsersController < ApplicationController

  before_filter :find_user, :only => :destroy
  before_filter :find_user_or_username, :except => [:destroy, :contact, :advertize, :report]

  def show
    @ad = AppConfiguration['ads']['user_profile_page']['left_section']
    username = @user.class.to_s == 'User' ? @user.name : @user
    @iphotos = Iphoto.listed.where("username = ?", username).paginate(:page => params[:page], :per_page => 6) #right now displaying favorites, will change to photos later
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

  def remove_all_photos
    if current_user.is_admin? || current_user == @user
      username = @user.class.to_s == 'User' ? @user.name : @user
      @iphotos = Iphoto.where("username = ?", username)
      @iphotos.destroy_all
      redirect_to user_url(@user), :notice => "All the photos are deleted."
    else
      redirect_to users_url, :notice => "UnAuthorized Access!!!"
    end
  end

  def destroy
    if current_user.is_admin? || current_user == @user
      @user.destroy
      redirect_to iphotos_path, :notice => "Your account is deleted successfully! We are sorry to see you go :("
    else
      redirect_to iphotos_path, :notice => "UnAuthorized Access!!!"
    end
  end

  def advertize
    unless request.post?
      render :template => 'users/advertize.html.erb', :layout => false
    else
      @contact = params[:contact]
      @errors = []
      if @contact
        ['name', 'email', 'company'].each do |field|
          @errors << "#{field.titleize} cannot be blank." if @contact[field].blank?
        end
        if @errors.empty?
          Notifier.advertize(@contact, 'Advertisement').deliver
          flash[:notice] = "Details sent successfully."
          render 'success.js.erb'
        else
          render 'errors.js.erb'
        end
      end
    end
  end

  def contact
    unless request.post?
      render :template => 'users/contact.html.erb', :layout => false
    else
      @contact = params[:contact]
      @errors = []
      if @contact
        ['name', 'email'].each do |field|
          @errors << "#{field.titleize} cannot be blank." if @contact[field].blank?
        end
        if @errors.empty?
          Notifier.contact(@contact, 'Contact').deliver
          flash[:notice] = "Contact sent successfully."
          render 'success.js.erb'
        else
          render 'errors.js.erb'
        end
      end
    end
  end 

   
  def report
    unless request.post?
      render :template => 'users/report.html.erb', :layout => false
    else
      @contact = params[:contact]
      @errors = []
      if @contact
        ['name', 'email', 'photo_url'].each do |field|
          @errors << "#{field.titleize} cannot be blank." if @contact[field].blank?
        end
        if @errors.empty?
          Notifier.contact(@contact, 'Contact').deliver
          flash[:notice] = "Report sent successfully."
          render 'success.js.erb'
        else
          render 'errors.js.erb'
        end
      end
    end
  end 

  private
    def find_user_or_username
      @user = User.where("id = ? or name = ?", params[:id], params[:id]).first
      unless @user
        @user = params[:id]
      end

      redirect_to iphotos_url unless @user      
    end

    def find_user
      @user = User.where("id = ? or name = ?", params[:id], params[:id]).first
      redirect_to iphotos_url unless @user      
    end    
end

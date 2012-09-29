class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?, :correct_user?

  private

    def authenticate_admin_user
      authenticate_or_request_with_http_basic do |user, password|
        user == AppConfiguration["admin_user"] && password == AppConfiguration["admin_password"]
      end
    end

    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def logged_in?
      return true if current_user
    end
    
    def correct_user?
      @user = User.find_by_id(params[:id])
      unless current_user == @user
        redirect_to root_url, :alert => "Access denied."
      end
    end

    def authenticate_user!
      if !current_user
        redirect_to root_url, :alert => 'You need to sign in for access to this page.'
      end
    end

    def reset_session
      session[:user_id] = nil
    end
end

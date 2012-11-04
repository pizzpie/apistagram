class AuthsController < ApplicationController

  def new
    redirect_to '/auth/instagram'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.authenticate(auth, partner)

    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end

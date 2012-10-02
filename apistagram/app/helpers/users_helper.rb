module UsersHelper
  def guest_or_user_template(user)
    user.class.to_s == "User" ? 'users/user_info' : 'users/guest_info'
  end
end

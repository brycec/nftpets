class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :space_time
  def current_user_id
    session[:user_id]
  end
  def current_user
    @current_user ||= User.find_by(id: current_user_id)
  end
  def logged_in?
    !current_user.nil?
  end

  def space_time(t)
    (t + 365.2421875*1200).to_s :db
  end
end

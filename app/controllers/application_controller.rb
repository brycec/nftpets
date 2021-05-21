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
  before_action do |c|
    if c.current_user
      path = request.path_parameters
      if @current_user.dead? and
        path[:action] != 'dead' and
        !path[:controller].in? ['messages','sessions']
        2.times do current_user.heat end
        flash.notice = nil
        redirect_to '/dead'
      elsif @current_user.took_damage?
        flash.alert = "🛑 SHTAHP! ✋ Your terminal overheated and the cpu took damage! 🔥📺🔥 That's cringe and you're going to loose tokens if you don't slow down."
        @current_user.cooldown?
        @current_user.save
        Event.create(user_id: current_user_id, key: "overheat", value: @current_user.damage?)
        redirect_to '/users/'+@current_user.id.to_s
      end
    end
  end
  def space_time(t)
    (t + 365.2421875*1200).to_s :db
  end
end

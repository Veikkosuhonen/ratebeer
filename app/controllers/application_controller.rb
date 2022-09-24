class ApplicationController < ActionController::Base
  before_action :set_photo
  helper_method :current_user

  def set_photo
    @photo = UnsplashApi.random
  end

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'you should be signed in' if current_user.nil?
  end

  def authenticate_admin
    redirect_to signin_path, notice: 'Only admin can do that' unless current_user&.is_admin?
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # returns an invalidation function
  def self.invalidate_cache(*keys)
    -> { keys.each { |key| expire_fragment(key); puts "expiring #{key}" } }
  end
end

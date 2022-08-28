class SessionsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:new, :create]
  def new
    # render signup
  end

  def create
    user = User.find_by username: params[:username]
    if user&.authenticate params[:password]
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    else
      redirect_to signin_path, notice: "Incorrect username or password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end

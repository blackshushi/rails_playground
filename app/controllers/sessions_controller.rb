class SessionsController < ApplicationController
  def new
    redirect_to rooms_path if current_user || guest_user?
  end

  def create
    if params[:guest]
      create_guest_session
    else
      create_user_session
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out'
  end

  private
  def create_guest_session
    if !params[:guest_name].present?
      flash.now[:alert] = "Please enter a name"
      render :new, status: :unprocessable_entity
      return
    end

    session[:guest_name] = params[:guest_name]
    redirect_to rooms_path, notice: "Welcome, #{params[:guest_name]}"
  end

  def create_user_session
    user = User.find_by(email: params[:email])
    if user || !user.authenticate(params[:password])
      flash.now[:alert] = 'Invalid email or password'
      render :new, status: :unprocessable_entity
      return
    end

    session[:user_id] = user.id
    redirect_to rooms_path, notice: 'Logged in successfully'
  end
end

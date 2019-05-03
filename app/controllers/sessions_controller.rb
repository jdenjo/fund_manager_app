class SessionsController < ApplicationController
  def new
    if !current_user.nil? 
      redirect_to "/positions/?id=#{current_user.id}"
    end
  end

  def create
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged In"
      redirect_to "/positions/?id=#{current_user.id}"
    else
      flash[:alert] = "Wrong email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to home_path, notice: "Logged out"
  end
end

class SessionsController < ApplicationController
  def new
    if !current_user.nil? 
      redirect_to "/positions/?id=#{current_user.id}"
    end
  end

  def create
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      # The session is an object useable in controllers
      # that uses cookies to store encrypted data. To
      # sign a user in, we store their user_id in the
      # session for later retrieval.
      session[:user_id] = user.id
      flash[:notice] = "Logged In"
      redirect_to positions_path
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

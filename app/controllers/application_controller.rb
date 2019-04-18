class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper

  def current_user
    if session[:user_id].present?
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  helper_method(:current_user)

  def commaNumber(number)
    return number_with_delimiter(number, :delimiter => ",")
  end

  helper_method(:commaNumber)

  def dateFormat(date)
    return date.strftime("%m/%d/%y  %I:%M%p")
  end

  helper_method(:dateFormat)

  def percentPnL(pnLPercent)
    return sprintf("%+.1f", ((pnLPercent).round(1)))
  end

  helper_method(:percentPnL)

  def tableDateFormat(date)
    return date.strftime("%m/%d/%y")
  end

  helper_method(:tableDateFormat)

  helper_method(:dateFormat)

  def user_signed_in?
    current_user.present?
  end

  helper_method(:user_signed_in?)

  def authenticate_user!
    unless user_signed_in?
      flash[:danger] = "You must sign in or sign up first"
      redirect_to new_sessions_path
    end
  end
end

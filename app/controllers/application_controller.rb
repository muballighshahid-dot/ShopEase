class ApplicationController < ActionController::Base
  helper_method :current_user, :admin_user?, :customer_user?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) || User.first
  end

  def admin_user?
    current_user&.role_admin?
  end

  def customer_user?
    current_user&.role_customer?
  end

  def require_admin!
    return if admin_user?

    redirect_to root_path, alert: "Only admin can manage products."
  end

  def require_customer!
    return if customer_user?

    redirect_to root_path, alert: "Only customers can perform this action."
  end
end

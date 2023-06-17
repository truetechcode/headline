module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def signed_in_user
    unless signed_in?
      store_location
      respond_to do |format|
        format.html { redirect_to new_session_url, flash: { success: "Please sign in." } }
        format.json { render json: { error: "Please sign in." }, status: :unauthorized }
      end
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end
end

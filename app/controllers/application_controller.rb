class ApplicationController < ActionController::Base
  # https://github.com/binarylogic/authlogic
  protect_from_forgery with: :exception
  helper :all
  helper_method :current_user_session, :current_user, :require_user, :require_no_user, :redirect_back_or_default

  private

    # <b>To get the +current_user+ session</b>
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    # <b>To get the current user</b>
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    # <b>To ensure the +current_user+ is identified/logged</b>
    def require_user
      unless current_user
        store_location
        flash[:notice] = I18n.t('user_session.you_must_be_logged')
        redirect_to new_user_session_path
        return false
      end
    end

    # <b>To ensure the +current_user+ is not yet identified/logged</b>
    def require_no_user
      if current_user
        store_location
        flash[:notice] = I18n.t('user_session.you_must_be_unlogged')
        redirect_to root_path
        return false
      end
    end

    # <b>To store the requested URL</b>
    def store_location
      session[:return_to] = request.url
    end

    # <b>To perform a redirect to the session stored location or to the +default+ location</b>
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

  protected

    # <b>To handle the unverified request</b>:
    # ensuring the +current_user_session+ to be destroyed
    # redirecting to the login page
    def handle_unverified_request
      current_user_session.try(:destroy)
      redirect_to root_path
    end

end

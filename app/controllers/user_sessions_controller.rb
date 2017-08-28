class UserSessionsController < ApplicationController
  # https://github.com/binarylogic/authlogic
  before_action :require_no_user, :only => [:new, :create]
  before_action :require_user,    :only => :destroy

  # <b>To start a new user session</b>
  def new
    @user_session = UserSession.new
  end

  # <b>To create a user session</b>
  def create
    @user_session = UserSession.new(user_session_params.to_h)
    if @user_session.save
      # flash[:notice] = I18n.t('user_session.login_successful')
      redirect_to surveys_path
    else
      flash[:notice] = I18n.t('user_session.invalid_login')
      render :action => :new
    end
  end

  # <b>To destroy a user session</b>
  def destroy
    current_user_session.destroy
    flash[:notice] = I18n.t('user_session.logout_successful')
    redirect_back_or_default new_user_session_path
  end

  private

    # <b>White list desired parameters</b>
    def user_session_params
      params.require(:user_session).permit(:email, :password, :remember_me)
    end

end
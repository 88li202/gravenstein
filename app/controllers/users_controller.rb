class UsersController < ApplicationController
  # https://github.com/binarylogic/authlogic
  before_action :require_no_user,          :only => [:new, :create]
  before_action :require_user,             :only => [:show, :edit, :update]
  before_action :set_user_as_current_user, :only => [:show, :edit, :update]

  # +SPEC+: <em>You don't need to worry about user authentication but you may stub this out if you wish.</em>
  # TODO: add an admin page to list & manage all users, including new user not yet granted/confirmed.

  # <b>To start a new user</b>
  def new
    @user = User.new
  end

  # <b>To create a user</b>
  def create
    @user = User.new(user_params)

    # For now there is no +user+ management page.
    # So we are activating, approving and confirming them by default!
    @user.active    = true
    @user.approved  = true
    @user.confirmed = true

    if @user.save
      flash[:notice] = I18n.t('user.registered')
      redirect_to surveys_path
    else
      render :action => :new
    end
  end

  # <b>To show a user</b>
  def show
  end

  # <b>To edit a user</b>
  def edit
  end

  # <b>To update a user</b>
  def update
    if @user.update_attributes(user_params)
      flash[:notice] = I18n.t('user.updated')
      redirect_to surveys_path
    else
      render :action => :edit
    end
  end

  private

    # <b>To make our views 'cleaner' and more consistent</b>
    def set_user_as_current_user
      @user = @current_user
    end

    # <b>White list desired parameters</b>
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :age, :password, :password_confirmation, :remember_me)
    end

end

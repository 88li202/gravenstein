require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
    @user.password              = Faker::Internet.password
    @user.password_confirmation = @user.password
    @user.active                = true
    @user.approved              = true
    @user.confirmed             = true
    assert @user.save
  end

  test 'should get new user' do
    get new_user_url
    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count') do
      post users_url, params: {
        user:
          {
            email:                 Faker::Internet.email,
            password:              (pwd=Faker::Internet.password),
            password_confirmation: pwd
          }
      }
    end
    assert_redirected_to surveys_url
  end

  test 'should show user' do
    # Not yet logged
    get user_url(@user)
    assert_redirected_to new_user_session_url

    # Logging a user through its creation
    assert_difference('User.count') do
      post users_url, params: {
        user:
          {
            email:                 Faker::Internet.email,
            password:              (pwd=Faker::Internet.password),
            password_confirmation: pwd
          }
      }
    end
    assert_redirected_to surveys_url

    # Users can see each others for now ! (no user management rules, no admin role, etc...)
    get user_url(@user)
    assert_response :success
  end

  test 'should update user' do
    # Not yet logged
    get user_url(@user)
    assert_redirected_to new_user_session_url

    # Logging a user through its creation
    assert_difference('User.count') do
      post users_url, params: {
        user:
          {
            email:                 Faker::Internet.email,
            password:              (pwd=Faker::Internet.password),
            password_confirmation: pwd
          }
      }
    end
    assert_redirected_to surveys_url

    # Users can update each others for now ! (no user management rules, no admin role, etc...)
    patch user_url(@user), params: { user: { age: 36 } }
    assert_redirected_to surveys_url
  end

  test 'should edit user' do
    # Not yet logged
    get user_url(@user)
    assert_redirected_to new_user_session_url

    # Logging a user through its creation
    assert_difference('User.count') do
      post users_url, params: {
        user:
          {
            email:                 Faker::Internet.email,
            password:              (pwd=Faker::Internet.password),
            password_confirmation: pwd
          }
      }
    end
    assert_redirected_to surveys_url

    # Users can edit each others for now ! (no user management rules, no admin role, etc...)
    get edit_user_url(@user)
    assert_response :success
  end

end

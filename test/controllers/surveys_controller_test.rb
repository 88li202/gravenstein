require 'test_helper'

class SurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.password              = Faker::Internet.password
    @user.password_confirmation = @user.password
    @user.active                = true
    @user.approved              = true
    @user.confirmed             = true
    assert @user.save
    @survey = Survey.create(
      question: Faker::MostInterestingManInTheWorld.quote + '?',
      surveyor: @user
    )
    assert @survey.persisted?
    # LOG IN
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

  test 'should get index' do
    get surveys_url
    assert_response :success

    @request.headers['Accept']       = Mime[:json]
    @request.headers['Content-Type'] = Mime[:json].to_s
    get surveys_url(format: :json)
    body = JSON.parse(response.body)
    assert body['data'].present?
  end

  test 'should get new' do
    get new_survey_url
    assert_response :success
  end

  test 'should create survey' do
    # +SPEC+: <em>A survey consists of one question represented as a single string.</em>
    # +SPEC+: <em>A user should be able to create any number of surveys.</em>
    assert_difference('Survey.count') do
      post surveys_url, params: { survey: {
        question: Faker::MostInterestingManInTheWorld.quote + '?',
        surveyor: @user
      } }
    end
    assert_redirected_to survey_url(Survey.last)
  end

  test 'should show survey' do
    get survey_url(@survey)
    assert_response :success
  end

  test 'should update survey' do
    patch survey_url(@survey), params: { survey: {
      is_active: false
    } }
    assert_redirected_to survey_url(@survey)
    assert !@survey.reload.is_active?
  end

end

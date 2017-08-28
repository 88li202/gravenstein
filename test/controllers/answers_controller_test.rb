require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest
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
    @answer = Answer.create(
      respondent: @user,
      survey:     @survey,
      yes_no:     Faker::Boolean.boolean
    )
    assert @answer.persisted?
  end

  test "should get index" do
    @request.headers['Accept']       = Mime[:json]
    @request.headers['Content-Type'] = Mime[:json].to_s
    get answers_url(format: :json, survey_id: @survey.id)
    body = JSON.parse(response.body)
    assert body['data'].present?
  end

  test "should create answer" do
    # +SPEC+: <em>The answer to the question is always Yes or No.</em>
    # +SPEC+: <em>A user can respond to a survey by clicking into it from the list discussed above.</em>
    assert_difference('Answer.count') do
      post answers_url(format: :js), params: {
        survey_id:  @survey.id,
        yes_no:     Faker::Boolean.boolean
      }
    end
  end

end

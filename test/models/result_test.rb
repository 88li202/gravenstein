require 'test_helper'

class ResultTest < ActiveSupport::TestCase

  def new_user
    @user = User.new({
                       first_name: Faker::Name.first_name,
                       last_name:  Faker::Name.last_name
                     })
    @user.email                 = Faker::Internet.email(@user.name)
    @user.age                   = Faker::Number.between(8, 88)
    @user.password              = Faker::Internet.password
    @user.password_confirmation = @user.password
    @user.active                = true
    @user.approved              = true
    @user.confirmed             = true
    assert @user.save
    @user
  end

  def new_survey(user)
    @survey = Survey.create(
      question: Faker::MostInterestingManInTheWorld.quote + '?',
      surveyor: user
    )
    assert @survey.persisted?
    @survey
  end

  def new_answer(user, survey)
    @answer = Answer.create(
      respondent: user,
      survey:     survey,
      yes_no:     Faker::Boolean.boolean
    )
    assert @answer.persisted?
    @answer
  end

  test 'Check the full flow up to the result creation' do
    users   = 5.times.map{new_user}
    assert users.present?

    # +SPEC+: <em>A user should be able to create any number of surveys.</em>
    surveys = 5.times.map{new_survey(users.sample)}
    assert surveys.present?

    # +SPEC+: <em>A survey can be answered multiple times with a yes/no response.</em>
    answers = 100.times.map{new_answer(users.sample, surveys.sample)}
    assert answers.present?

    assert surveys.sample(rand(1..surveys.size)).map(&:close).all?
    assert Survey.denormalize_all
    assert (Survey.pending_denormalization.count == 0)
  end

end
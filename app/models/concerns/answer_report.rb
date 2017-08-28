module AnswerReport
  extend ActiveSupport::Concern

  # +SPEC+: <em>You should keep track of when each of the survey responses are saved.</em>
  # Table/report columns
  COLUMNS = [
    :respondent_name,
    :respondent_age,
    :answer_humanized,
    :created_at
  ].freeze

  # Table/report sorting map
  COLUMNS_SORT = [
    'users.first_name',
    'users.age',
    'answers.yes_no',
    'answers.created_at'
  ].freeze

end

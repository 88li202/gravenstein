module SurveyReport
  extend ActiveSupport::Concern

  # Table/report columns
  COLUMNS = [
    :surveyor_name,
    :status,
    :created_at,
    :question,
    :answers,
    :vote,
    :view
  ].freeze

  # Table/report sorting map
  COLUMNS_SORT = [
    'users.first_name',
    'surveys.is_active',
    'surveys.created_at',
    'surveys.question'
  ].freeze

end
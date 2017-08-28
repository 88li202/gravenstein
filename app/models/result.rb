class Result < ApplicationRecord
  # Relations
  belongs_to :survey

  # Validations
  validates :survey_id, presence: true

  # Serialization
  serialize :answers_by_age_groups

end
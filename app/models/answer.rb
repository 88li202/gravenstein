class Answer < ApplicationRecord
  # Relations
  belongs_to :respondent, class_name: User.name, foreign_key: :respondent_id
  belongs_to :survey

  # Validations
  # +SPEC+: <em>The answer to the question is always Yes or No.</em>
  # +SPEC+: <em>A survey can be answered multiple times with a yes/no response.</em>
  validates :respondent_id, presence: true
  validates :survey_id,     presence: true
  validates :yes_no,        inclusion: { in: [ true, false ] } # +presence: true+ won't work here, +yes_no+ is a boolean

  # Scopes
  scope :no,  -> { where(yes_no: false) }
  scope :yes, -> { where(yes_no: true ) }

  # Concerns
  include AnswerReport

  # <b>To humanize the answer</b>
  # +SPEC+: <em>The answer to the question is always Yes or No.</em>
  def answer_humanized
    I18n.t(yes_no ? 'answer.yes' : 'answer.no')
  end

  # <b>To fetch the respondent age</b>
  def respondent_age
    @respondent_age ||= respondent.age
  end

  # <b>To fetch the respondent name</b>
  def respondent_name
    @respondent_name ||= respondent.name
  end

  class << self

    # <b>To get the answers related to the survey</b>
    # the returned answers are paginated, ordered and possibly filtered by a search criteria.
    # With parameters:
    # - the +survey_id+
    # - the +draw+ counter
    # - the +search+ criteria
    # - the +start+ point
    # - the +length+
    # - the +order_by+ column
    # - the +order_dir+ direction
    def get_answers_report(survey_id, draw, search, start, length, order_by, order_dir)

      # Skip if the survey does not exist.
      return [] unless Survey.exists?(survey_id)

      # We want the answers related to the existing survey.
      # We are eager loading the respondents (we need their name,... for filtering & displaying purpose).
      # TODO: optimize the eager load, selecting only the respondent attributes we will use for filtering & displaying purpose.
      answers_rel = Answer.eager_load(:respondent).where(survey_id: survey_id)

      # Searching/Filtering by
      # - respondent +first_name+
      # - respondent +last_name+
      answers_rel.where!("(users.first_name LIKE ? OR users.last_name LIKE ?)", "%#{search}%", "%#{search}%") if search.present?

      # Ordering (using the +COLUMNS_SORT+ ordering map)
      answers_rel.order!("#{Answer::COLUMNS_SORT[order_by.to_i]} #{order_dir}") if Answer::COLUMNS_SORT[order_by.to_i].present? && %w(asc desc).include?(order_dir)

      # The result is an array composed of:
      # - the +draw+ count
      # - the total number of answers for the existing survey (without filtering or paging)
      # - the total number of answers for the existing survey, filtered with the search criteria
      # - the answers (after filtering, sorting and paginating)
      [
        draw,
        Answer.where(survey_id: survey_id).count,
        answers_rel.clone.count, # we +clone+ the active record relation to be able to reuse it below.
        answers_rel.offset(start).limit(length)
      ]

    end

  end

end

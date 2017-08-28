class Survey < ApplicationRecord
  # Relations
  # +SPEC+: <em>A user should be able to create any number of surveys.</em>
  has_many   :answers
  belongs_to :result, optional: true
  belongs_to :surveyor, class_name: User.name, foreign_key: :surveyor_id

  # Validations
  # +SPEC+: <em>A survey consists of one question represented as a single string.</em>
  validates :question,    presence: true
  validates :question,    uniqueness: true, if: Proc.new{|survey| Survey.active.where(question: survey.question).exists? }
  validates :surveyor_id, presence: true

  # Scopes
  scope :active,                  -> { where(is_active: true ) }
  scope :closed,                  -> { where(is_active: false) }
  scope :pending_denormalization, -> { where(is_active: false).where(result_id: nil) }

  # Concerns
  include SurveyReport

  # <b>Get answers by age grouops</b>
  def answers_by_age_groups
    @answers_by_age_groups ||= result.try(:answers_by_age_groups) ||
      Hash[
        *answers.
          joins(:respondent).
          group('users.age / 10').
          count.
          map{ |age_dec, count| ["#{age_dec * 10}#{I18n.t('survey.plus_year_old')}" , count] }.
          flatten
      ]
  end

  # <b>To fetch the total number of answers</b>
  def answers_count
    @answers_count ||= result.try(:answers_count) || answers.count
  end

  # <b>To close a survey</b>
  def close
    self.is_active = false
    save
  end

  # <b>To denormalize the survey stats to a result record</b>
  # step 1: denormalize the +survey+ to a new +result+ record
  # - +answers_by_age_groups+
  # - +answers_count+
  # - +percentage_yes+
  # step 2:
  # - delete all the +answers+ of the +survey+
  # Final goal is to keep only the survey main outputs (stats/trends, ...) saved in a result record.
  # and to cleanup the database (removing the answers records, useless at this point).
  def denormalize
    return false if is_active? # Denormalizing ONLY if the survey is closed
    return true if result.present? # Already dernormalized!
    self.result = Result.create(
      answers_by_age_groups: answers_by_age_groups,
      answers_count: answers_count,
      percentage_yes: percentage_yes,
      survey_id: id
    )
    save && answers.destroy_all
  end

  # <b>To fetch the percentage of 'yes' answers</b>
  def percentage_yes
    @percentage_yes ||= result.try(:percentage_yes) || (answers_count == 0 ? 0 : (100 * answers.yes.count.to_f / answers_count.to_f).round)
  end

  # <b>To fetch the percentage of 'no' answers</b>
  def percentage_no
    @percentage_no ||= (100.0 - @percentage_yes)
  end

  # <b>To humanize the status</b>
  def status
    is_active ? I18n.t('survey.active') : I18n.t('survey.closed')
  end

  # <b>To fetch the surveyor age</b>
  def surveyor_age
    @surveyor_age ||= surveyor.age
  end

  # <b>To fetch the surveyor name</b>
  def surveyor_name
    @surveyor_name ||= surveyor.name
  end

  class << self

    # <b>To denormalize all closed surveys not yet denormalized</b>
    # used by the denormalize rake task
    # cf. +denormalize+
    def denormalize_all
      Survey.pending_denormalization.map(&:denormalize).all?
    end

    # <b>To get the surveys</b>
    # the returned surveys are paginated, ordered and possibly filtered by a search criteria.
    # With parameters:
    # - the +draw+ counter
    # - the +search+ criteria
    # - the +start+ point
    # - the +length+
    # - the +order_by+ column
    # - the +order_dir+ direction
    def get_surveys_report(draw, search, start, length, order_by, order_dir)

      # We are eager loading the surveyors (we need their name,... for filtering & displaying purpose).
      surveys_rel = Survey.eager_load(:surveyor)

      # Searching/Filtering by
      # - surveyor +first_name+
      # - surveyor +last_name+
      # - +question+ of the survey
      surveys_rel.where!("(users.first_name LIKE ? OR users.last_name LIKE ? OR question LIKE ?)", "%#{search}%", "%#{search}%", "%#{search}%") if search.present?

      # Ordering (using the +COLUMNS_SORT+ ordering map)
      surveys_rel.order!("#{Survey::COLUMNS_SORT[order_by.to_i]} #{order_dir}") if Survey::COLUMNS_SORT[order_by.to_i].present? && %w(asc desc).include?(order_dir)

      # The result is an array composed of:
      # - the +draw+ count
      # - the total number of surveys (without filtering or paging)
      # - the total number of surveys filtered with the search criteria
      # - the surveys (after filtering, sorting and paginating)
      [
        draw,
        Survey.count,
        surveys_rel.clone.count, # we +clone+ the active record relation to be able to reuse it below.
        surveys_rel.offset(start).limit(length)
      ]

    end

  end

end

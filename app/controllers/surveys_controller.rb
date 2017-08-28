class SurveysController < ApplicationController
  # Ensure access only to granted users
  before_action :require_user
  before_action :set_survey, only: [:show, :update]

  # <b>To list the surveys</b>
  # With pagination, searching/filtering and ordering.
  # Parameters are:
  # - the +draw+ counter
  # - the +start+ point
  # - the +length+
  # - the +order+ hash (+column+ id and order +dir+ection)
  # - the +search+ hash (+value+ is the criteria)
  def index
    respond_to do |format|

      # For the HTML call, do not provide data (data will be served by XHR calls)
      format.html { @surveys = [] }

      # XHR call to get table/report data.
      format.json {
        # https://datatables.net/manual/server-side
        # The result is an array composed of:
        # - the +draw+ count
        # - the total number of surveys (without filtering or paging)
        # - the total number of surveys filtered with the search criteria
        # - the surveys (after filtering, sorting and paginating)
        @draw, @records_total, @records_filtered, @surveys = Survey.get_surveys_report(
          survey_params_json[:draw],                            # Draw counter
          survey_params_json[:search].to_h['value'],            # Search criteria
          survey_params_json[:start],                           # Paging first record indicator
          survey_params_json[:length],                          # Number of records for the draw
          Hash(survey_params_json[:order].to_h['0'])['column'], # Order by the column number
          Hash(survey_params_json[:order].to_h['0'])['dir']     # Order direction
        )
      }

    end
  end

  # <b>To show a survey</b>
  # Parameters are:
  # - the +id+ of the survey
  def show
  end

  # <b>To start a new survey</b>
  def new
    @survey = Survey.new
  end

  # <b>To create a survey</b>
  # Parameters are:
  # - the +question+ of the survey
  # +SPEC+: <em>A survey consists of one question represented as a single string.</em>
  # +SPEC+: <em>A user should be able to create any number of surveys.</em>
  def create
    @survey = Survey.new(survey_params)
    @survey.surveyor = current_user
    @survey.save ? redirect_to(@survey, notice: I18n.t('survey.created_successfully')) : render(:new)
  end

  # <b>To update a survey (to close it, updating the status)</b>
  # Parameters are:
  # - the +id+ of the survey
  # - the +is_active+ status of the survey
  def update
    @survey.update(survey_params) ? redirect_to(@survey, notice: I18n.t('survey.updated_successfully')) : render(:show)
  end

  private

    # <b>Fetch the survey using its +id+</b>
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # <b>White list desired parameters (HTTP calls)</b>
    def survey_params
      params.require(:survey).permit(:question, :is_active)
    end

    # <b>White list desired parameters (JSON calls)</b>
    def survey_params_json
      params.permit(:draw, :start, :length, order: {}, search: {})
    end

end

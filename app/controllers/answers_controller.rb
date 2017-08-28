class AnswersController < ApplicationController
  # Ensure access only to granted users
  before_action :require_user

  # <b>To list the answers corresponding to the provided survey</b>
  # With pagination, searching/filtering and ordering.
  # Parameters are:
  # - the +survey_id+
  # - the +draw+ counter
  # - the +start+ point
  # - the +length+
  # - the +order+ hash (+column+ id and order +dir+ection)
  # - the +search+ hash (+value+ is the criteria)
  def index
    respond_to do |format|
      # XHR call to get table/report data.
      format.json {
        # https://datatables.net/manual/server-side
        # The expected result is an array composed of:
        # - the +draw+ count
        # - the total number of answers for the existing survey (without filtering or paging)
        # - the total number of answers for the existing survey, filtered with the search criteria
        # - the answers (after filtering, sorting and paginating)
        @draw, @records_total, @records_filtered, @answers = Answer.get_answers_report(
          answer_params_json[:survey_id],                       # Survey id
          answer_params_json[:draw],                            # Draw counter
          answer_params_json[:search].to_h['value'],            # Search criteria
          answer_params_json[:start],                           # Paging first record indicator
          answer_params_json[:length],                          # Number of records for the draw
          Hash(answer_params_json[:order].to_h['0'])['column'], # Order by the column number
          Hash(answer_params_json[:order].to_h['0'])['dir']     # Order direction
        )
      }
    end
  end

  # <b>To create an answer (through an XHR call)</b>
  # Parameters are:
  # - the +survey_id+
  # - the +yes_no+ answer
  # +SPEC+: <em>A user can respond to a survey by clicking into it from the list discussed above.</em>
  def create
    respond_to do |format|
      format.js {
        # Formatting the parameters
        params                 = answer_params_js.to_h
        params[:yes_no]        = params[:yes_no] == 'true'
        params[:respondent_id] = current_user.id

        # Creating the answer
        @answer = Answer.new(params)
        @answer.save
      }
    end
  end

  private

    # <b>White list desired parameters (JS calls)</b>
    def answer_params_js
      params.permit(:survey_id, :yes_no)
    end

    # <b>White list desired parameters (JSON calls)</b>
    def answer_params_json
      params.permit(:survey_id, :draw, :start, :length, order: {}, search: {})
    end

end

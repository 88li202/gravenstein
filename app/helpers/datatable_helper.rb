# Helper to generate the Datatable HTML object with its javascript variables.
# https://datatables.net

module DatatableHelper

  # DataTable canvas
  # With parameters:
  # - +instance+ of an ApplicationRecord child
  # required: Model::COLUMNS      (columns definition)
  # optional: Model::COLUMNS_SORT (columns sort map)
  def datatable_table(model, instance=nil)
    # Nothing to do
    return h('') if model&.const_get(:COLUMNS).blank?

    # create the model_columns js variable
    javascript_tag(%{var #{model.name.downcase.pluralize}_columns = #{
      Array(model.const_get(:COLUMNS)).each_with_index.map{|c, i|
        { data: c, orderable: Array(model.const_get(:COLUMNS_SORT))[i].present? }
      }.to_json
    }}) +

    # create the model_id js variable
    (instance.present? ? javascript_tag("var #{instance.class.name.downcase}_id = #{instance.id}") : h('')) +

    # provide an auth_token for ajax POST XHR
    (javascript_tag("var ajax_auth_token = #{form_authenticity_token.to_json}")) +

    # table canvas itself with initialised columns
    div_tag(class: %w(container-fluid)) do
      table_tag(id: model.name.downcase.pluralize, class: %w(table table-striped table-bordered), cellspacing: 0, width: '100%') do
        thead_tag do
          tr_tag{ safe_join(Array(model.const_get(:COLUMNS)).map{ |c| th_tag(){ c.to_s.sub(/to_s|_humanized/i, '').humanize } }) } +
          tbody_tag
        end
      end
    end
  end

end
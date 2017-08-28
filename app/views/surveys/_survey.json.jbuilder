json.extract! survey, :surveyor_name, :status, :created_at, :question

if survey.answers_count > 0
  json.answers(
    div_tag(class: %(progress)){
      progress_bar(survey.percentage_yes) + progress_bar(survey.percentage_no, :danger)
    }
  )
else
  json.answers span_tag(class: %w(badge badge-info)){ t('survey.no_answers') }
end

if survey.is_active?
  # +SPEC+: <em>A user can respond to a survey by clicking into it from the list discussed above.</em>
  json.vote(
    div_tag(id: "vote_#{survey.id}", class: %w(btn-group), role: :group, 'aria-label': t('answer.vote')){
      button_tag(:yes, type: :button, onclick: "vote($(this).attr('data-href'));", 'data-href': answers_path(format: :js, survey_id: survey.id, yes_no: true ), class: %w(btn btn-secondary btn-sm btn-success)) +
      button_tag(:no,  type: :button, onclick: "vote($(this).attr('data-href'));", 'data-href': answers_path(format: :js, survey_id: survey.id, yes_no: false), class: %w(btn btn-secondary btn-sm btn-danger ))
    } +
    div_tag(id: "result_#{survey.id}", style: 'display: none;'){
      span_tag(class: %w(badge badge-success), style: 'display: none;'){ t('answer.saved') } +
      span_tag(class: %w(badge badge-danger),  style: 'display: none;'){ t('answer.cant_save') }
    }
  )
else
  json.vote span_tag(class: %w(badge badge-info)){ t('survey.closed') }
end

json.view link_to(:view, survey_path(survey), class: %w(btn btn-sm btn-info))

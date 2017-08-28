json.draw            @draw
json.recordsTotal    @records_total
json.recordsFiltered @records_filtered
json.data do
  json.array! @surveys, partial: 'surveys/survey', as: :survey
end
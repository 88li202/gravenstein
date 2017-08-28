json.draw            @draw
json.recordsTotal    @records_total
json.recordsFiltered @records_filtered
json.data do
  json.array! @answers, partial: 'answers/answer', as: :answer
end
$ ->
  $_event_types = $('#event_item_event_type_id')
  $_event_type_fields = $('#event_type_fields')
  clearForm = ->


  $('#event_item_pillar_id').change( ->
    $_event_types.empty()
    $_event_type_fields.empty()
    $.get '/pillars/'+$(this).val()+'/event_types', (event_types)->
      $.each event_types, (id, event_type)->
        $_event_types.append $('<option/>').val(event_type.id).html(event_type.title)
      $_event_types.trigger('change')
  ).trigger('change')

  $_event_types.change ->
    $_event_type_fields.empty()
    $.get '/event_types/'+$(this).val()+'/event_descriptors.html', (fields)->
      $_event_type_fields.html(fields)
      $(".datepicker").datepicker()


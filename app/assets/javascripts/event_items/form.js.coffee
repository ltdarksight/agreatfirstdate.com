$ ->
  $_event_types = $('#event_item_event_type_id')
  $_event_type_fields = $('#event_type_fields')
  $_dialog = $("#add_event_lightbox");

  $('#event_item_pillar_id').change( ->
    $_event_types.empty()
    $_event_type_fields.empty()
    $.get '/pillars/'+$(this).val()+'/event_types', (event_types)->
      $.each event_types, (id, event_type)->
        $_event_types.append $('<option/>').val(event_type.id).html(event_type.title).data('has_attachments', event_type.has_attachments)
      $_event_types.trigger('change')
  ).trigger('change')

  $_event_types.change ->
    $_event_type_fields.empty()
    $.get '/event_types/'+$(this).val()+'/event_descriptors.html', (fields)->
      $_event_type_fields.html(fields)
      $(".datepicker").datepicker()
      $('.event_photo_form_wrapper_').toggle($_dialog.find('.event_photo_ids_').length > 0).find('.event_photos_previews_').empty()

  $(document).delegate '.event_photo_image_', 'change', ->
    $(this).closest('form').submit()
    $('.upload-status_').html('Uploading...')

this.deleteImage = (id)->
  $('.event_photo_ids_').find('#event_photo_'+id).remove()
  $('.event_photo_form_wrapper_').find('#image_'+id).remove()
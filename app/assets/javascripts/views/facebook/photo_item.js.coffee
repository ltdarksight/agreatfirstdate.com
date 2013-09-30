Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.PhotoItem extends Backbone.View
  template: JST["facebook/photo_item"]
  tagName: 'li'
  className: 'photo-item'

  events:
    'click .facebook-photo': 'select'

  render: ->
    $(@el).html @template(model: @model)
    this

  select: ->
    item = $(@el).find('.facebook-photo')
    if item.hasClass('selected')
      item.removeClass('selected')
    else
      item.addClass('selected')
    false
    # src_big = $(e.target).data('src_big')
    # if $(e.target).hasClass('selected')
    #   $(e.target).removeClass("selected");
    #   $("[name='event_photo[remote_image_url][]'][value="+src_big+"]", "#new_event_photo").remove()
    #   i = $('.photos_count span').html()
    #   $('.photos_count span').html(--i)

    # else
    #   if(@target == "edit_photo")
    #     $("#edit-photo").append("<input type='hidden' name='avatars[][remote_image_url]' value='"+src_big+"'>");
    #     $('#edit-photo').on "ajax:error", (e, response)=>
    #       response_errors = $.parseJSON(response.responseText);
    #       errors = []
    #       for key, error of response_errors
    #         errors.push(error)
    #       $(".album_error").html(errors.join(", "))

    #     $('#edit-photo').submit()

    #   if (true && !$(e.target).hasClass('selected') )
    #     $(e.target).addClass('selected')
    #     i = $('.photos_count span').html()
    #     $('.photos_count span').html(++i)
    #     $("#new_event_photos").append("<input type='hidden' name='event_photo[remote_image_url][]' value='"+src_big+"'>");

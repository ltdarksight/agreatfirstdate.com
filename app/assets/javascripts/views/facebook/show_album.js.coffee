Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.ShowAlbum extends Backbone.View
  template: JST['facebook/show_album']
  photoItemTemplate: JST['facebook/photo_item']

  initialize: ->
    _.bindAll @, "handleCloseSubwindow"
    @render()
    @target = @.options.parent.options.target
    @model.on "change", @renderItems, this
    @model.fetch()

  events:
    "click .btn.save": 'save'
    "hidden": 'handleCloseSubwindow'

  handleCloseSubwindow: (event)->
    @.options.parent.trigger "subwindow:close" if @.options.parent

  save: (event) ->
    if (@target == "edit_photo")
      @modal.hide()
      @.options.parent.trigger "subwindow:close" if @.options.parent

    else
      if !!$("img.selected", @.$el).length
        $(".modal-body", @.$el).html("Import images")
        $('#new_event_photos').on "ajax:complete", =>
          @modal.hide()
          @.options.parent.trigger "subwindow:close" if @.options.parent

        $('#new_event_photos').submit()
      else
        @modal.hide()
        @.options.parent.trigger "subwindow:close" if @.options.parent

  renderItems: ->
    _.each @model.get("photos"), (photo, i) ->
      item = new Agreatfirstdate.Views.Facebook.PhotoItem
        model: photo
      $(@el).find('.facebook-photos').append item.render().el
    , this



  render: ->
    @modal = new Agreatfirstdate.Views.Application.Modal
      header: 'aGreatFirstDate - Profile'
      body: @template(album: @model)
      el: @el
      view: @

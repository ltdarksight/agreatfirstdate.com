Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.ShowView extends Backbone.View
  template: JST["backbone/event_items/show/show"]

  initialize: (options)->
    super
    @setElement $("#event_items_popup")
    @me = options.me
    @user = options.user
    @allowEdit = @collection.allowEdit

    currentIndex = @collection.indexOf @model
    @previous = @collection.previousTo currentIndex
    @next = @collection.nextTo currentIndex
    @inappropriateContent = @model.inappropriateContent

    @buttons = $(@el).closest('.ui-dialog').find('.ui-dialog-buttonset')
    if @me.is('admin') && @me != @user
      @model.on 'change:status', @renderAdminButtons, this
      @inappropriateContent.on 'change:status', @renderAdminButtons, this
      @renderAdminButtons()
    if @allowEdit
      @inappropriateContent.on 'change:status', @renderUserButtons, this
      @renderUserButtons()

  fixInappropriate: (e)=>
    e.preventDefault()
    e.stopPropagation()
    @inappropriateContent.sync 'fix', @inappropriateContent, success: (inappropriateContent)=>
      @inappropriateContent.set(inappropriateContent)

  activate: (e)=>
    e.preventDefault()
    e.stopPropagation()
    @model.sync 'activate', @model, success: (user)=>
      @model.set('status', user.status)

   deactivate: (e)=>
    e.preventDefault()
    e.stopPropagation()
    @deactivateView = new Agreatfirstdate.Views.Shared.DeactivateView(me: @me, model: @model)

    $(@deactivateView.render().el).dialog
      height: 200
      width: 640
      resizable: false
      draggable: false
      modal: true,
      buttons:
        "Deactivate": =>
          @deactivateView.update()
          $(@deactivateView.el).dialog('close')

        "Cancel": -> $(this).dialog('close')

  stillInappropriate: (e)=>
    e.preventDefault()
    e.stopPropagation()
    @model.sync 'still_inappropriate', @model, success: (user)=>
      @inappropriateContent.set(user.inappropriate_content)

  render: ->
    $(@el).html @template($.extend(@model.toJSON(false),
      current: @model.id,
      previous: @previous
      next: @next
      pillar: @collection.pillar.toJSON()
      allowEdit: @collection.allowEdit))

    _.each [@previous, @next], (event)->
      if event
        view = new Agreatfirstdate.Views.EventItems.EventPreviewView({model: event})
        @$('.events').append(view.render().el)
    , this

    unless @model.hasDate()
      @$('.fields').append(JST["backbone/event_items/show/field"]({label: 'Posted', value: @model.get('date_1')}))

    _.each @model.toJSON(false).fields, (value, iteratorId, list) ->
      fieldValue = @model.attributes[value.field]
      if (fieldValue)
        @$('.fields').append(JST["backbone/event_items/show/field"]({label: value.label, value: fieldValue}))
    , this
    if @model.eventPhotos.length
      view = new Agreatfirstdate.Views.EventItems.ShowPhotosView({model: @model})
      @$('.images').html(view.render().el)
    return this

  renderAdminButtons: =>
    @buttons.find('.deactivate_, .activate_, .still-inappropriate_').remove()
    if 'active' == @model.get('status')
      @buttons.append(@make('a', href: '#', class: 'deactivate_', 'Inappropriate'))
    else
      @buttons.append(@make('a', href: '#', class: 'activate_ ', 'Appropriate'))
      if 'awaiting' == @inappropriateContent.get('status')
        @buttons.append(@make('a', href: '#', class: 'still-inappropriate_', 'Still Inappropriate'))

    @buttons.find('.activate_').click @activate
    @buttons.find('.deactivate_').click @deactivate
    @buttons.find('.still-inappropriate_').click @stillInappropriate

  renderUserButtons: =>
    @buttons.find('.fixed_').remove()
    unless 'active' == @model.get('status')
      if 'awaiting' == @inappropriateContent.get('status')
        @buttons.append(@make('span', class: '', "Waiting for admin response"))
      else
        @buttons.append(@make('a', href: '#', class: 'fixed_', "It's appropriate now"))
        @buttons.find('.fixed_').click @fixInappropriate

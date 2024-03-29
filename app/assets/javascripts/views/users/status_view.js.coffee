Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.StatusView extends Backbone.View
  profileTemplate: JST["backbone/user/status_profile"]
  eventsTemplate: JST["backbone/user/status_events"]
  eventTemplate: JST["backbone/user/status_event"]

  initialize: (options) ->
    super(options)
    @inappropriateContent = @model.inappropriateContent
    @inappropriateContents = @model.inappropriateContents

    @setElement($('#profile_status'))
    @model.on 'change:status', @render, this
    @inappropriateContent.on 'change:status', @render, this

  events:
    'click .fixed_': 'fixInappropriate'
    'click .show-reason_': 'showReason'
    'click .hide-reason_': 'hideReason'

  fixInappropriate: (e)->
    e.preventDefault()
    e.stopPropagation()
    @inappropriateContent.sync 'fix', @inappropriateContent, success: (inappropriateContent)=>
      @inappropriateContent.set(inappropriateContent)

  showReason: (e)->
    e.preventDefault()
    e.stopPropagation()
    @$('.show-reason_').replaceWith(@make('a', href: '#', class: 'hide-reason_', 'Hide'))
    @$('.reason_').html(@inappropriateContent.get('reason'))

  hideReason: (e)->
    e.preventDefault()
    e.stopPropagation()
    @$('.hide-reason_').replaceWith(@make('a', href: '#', class: 'show-reason_', 'Show Reason'))
    @$('.reason_').empty()

  render: ->
    $(@el).empty()

    if @model.locked()
      $(@el).append(@profileTemplate(@inappropriateContent.toJSON(false)))

    if @inappropriateContents.length
      $(@el).append(@eventsTemplate(@inappropriateContents.toJSON(false)))
      @inappropriateContents.each (inappropriateContent)=>
        @$('.events_').append(@eventTemplate(inappropriateContent.toJSON(false)))

    if @model.canceled()
      $("<div class='alert'></div>").html("You have marked your profile inactive.  You can reactivate it on the <a href='/me/edit'>settings</a> page.").appendTo $(@el)


    return this
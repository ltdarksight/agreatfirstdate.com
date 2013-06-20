Agreatfirstdate.Views.Search ||= {}
class Agreatfirstdate.Views.Search.NotChoosePillars extends Backbone.View

  initialize: ->
    @render()

  render: ->
    notify = new Agreatfirstdate.Views.Application.Notification
      head: "Error"
      body: "<p style='color:red;'>Oops!  You haven't selected any pillars yet.  We match you based on those pillars so please select at least one pillar before trying to search.</p>"
      view: @

    @

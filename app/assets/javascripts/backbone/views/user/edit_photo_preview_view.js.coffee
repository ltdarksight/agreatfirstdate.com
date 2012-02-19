Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditPhotoPreviewView extends Backbone.View
  template: JST["backbone/user/photo/preview"]

  initialize: (options) ->
    super(options)
    @user = options.user
    @model.on 'crop', (model)->
      @render()
    , this

  events:
    'click .destroy_': 'destroy'
    'click img': 'showLarge'

  showLarge: (e)->
    largeView = new Agreatfirstdate.Views.User.EditPhotoLargeView({model: @model, user: @user})
    @$('img').closest('.edit-photos_').find('.large_').html(largeView.render().el)

  destroy: (e)->
    @user.save('avatars_attributes', [{id: @model.id, _destroy: true}], {
      success: (user, response)->
        user.avatars.reset response.avatars
    });
    return false

  render : ->
    $(@el).html(@template(@model.toJSON()))
    return this



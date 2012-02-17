Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditPhotoPreviewView extends Backbone.View
  template: JST["backbone/user/photo/preview"]

  initialize: (options) ->
    super(options)
    @user = options.user
    console.log @user

#  events:
#    'click .destroy_': 'destroy'

#  destroy:
#    @user.save('avatars_attributes', [{id: @model.id, _destroy: true}], {success: -> alert('ok')});

  render : ->
    $(@el).html(@template(@model.toJSON()))
    return this



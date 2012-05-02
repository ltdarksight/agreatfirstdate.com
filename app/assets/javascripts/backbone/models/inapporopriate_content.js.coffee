class Agreatfirstdate.Models.InappropriateContent extends Backbone.Model
  paramRoot: 'inappropriate_content'
  urlRoot: '/inappropriate_contents'

  methodUrl:
    'fix': '/inappropriate_contents/:id/fix'

  defaults:
    reason: ''

  sync: (method, model, options) =>
    options = options || {}
    if _.include _(@methodUrl).keys(), method
      options.url = @methodUrl[method.toLowerCase()].replace(':id', model.id);
      method = 'update'
    Backbone.sync(method, model, options)

class Agreatfirstdate.Collections.InappropriateContentsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.InappropriateContent

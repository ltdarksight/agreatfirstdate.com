class Agreatfirstdate.Collections.SearchResults extends Backbone.Collection
  model: Agreatfirstdate.Models.User
  url: 'api/searches'
  page: 1
  totalEntries: 0
  itemsPerPage: 5
  loadedPages: []
  addCallback: null

  add: (data, options)->
    @page = parseInt data.page

    @totalEntries = data.total_entries
    super data.results
    models = []
    _.each @models, (model)=>
      if _.isUndefined(model.position)
        model.position = models.length + (@page-1)*@itemsPerPage
        models.push(model)
    if @page == 1
      @trigger('resetCollection', this)
      @loadedPages = []
    else
      @trigger('pageAdd', models)

    @loadedPages.push(@page)
    @addCallback() if @addCallback
    @addCallback = null

  removeItem: (model, options)->
    @totalEntries--
    index = @indexOf model
    @remove(model, options)
    _.each @models, (model, i)=> model.position = i
    @trigger('removeItem', this, index)

  pageLoaded: (page)->
    return true if page < 1 || Math.ceil(@totalEntries/@itemsPerPage) < page
    _.include @loadedPages, page

  loadPage: (page, options)->
    options = if options then _.clone(options) else {}
    @addCallback = options.success
    @fetch(data: $.extend(@userSearch.searchTerms(), page: page), add: true) unless @pageLoaded(page)
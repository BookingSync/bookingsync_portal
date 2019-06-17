class @ListBackedFilter
  constructor: (header, list, @listElement, @listFilterable, @inputId, formTemplate, paginationTemplate) ->
    @header = $(header)
    @list = $(list)
    @form = $(formTemplate)
    @insertForm()
    @observeInputChanges()
    
    @paginationTemplate ||= $(HandlebarsTemplates["pagination"]())
    @insertPagination()
    @observePageChanges()

    @loadingTemplate = $(HandlebarsTemplates["loading"]()) 

    @doneTypingInterval = 1500 # 1.5 seconds wait after each keyup before sending search request
    @typingTimer = undefined

  insertForm: ->
    @form.appendTo(@header)
    @input = $("#" + @inputId)

  insertPagination: ->
    @paginationTemplate.find("[data-type=previous]").addClass("disabled")
    @setPage(1)
    $(@paginationTemplate).appendTo(@list.parent())

  setPage: (page)->
    $(@form).data("current-page", page)

  currentPage: ->
    $(@form).data("current-page")

  firstPage: ->
    @currentPage() == 1

  lastPage: ->
    if @form.parents(".bookingsync-rentals-list").length > 0
      @list.find('.panel.panel-bookingsync.bookingsync-rental').length < $("body").data("items-per-page")
    else
      @list.find('.panel.panel-connected').length < $("body").data("items-per-page")

  observeInputChanges: ->
    @input.on 'keyup', =>
      @setPage(1)
      @displayWaiting()
      clearTimeout(@typingTimer)
      @typingTimer = setTimeout(@backendSearch, @doneTypingInterval) # make search request only when user is done typing

  observePageChanges: ->
    @paginationTemplate.find("[data-type=previous]").on "click", @goToPreviousPage
    @paginationTemplate.find("[data-type=next]").on "click", @goToNextPage

  displayWaiting: ->
    @list.html(@loadingTemplate) unless @list.children()[0] == @loadingTemplate[0]
    @paginationTemplate.find("[data-type=previous]").addClass("disabled")
    @paginationTemplate.find("[data-type=next]").addClass("disabled")

  backendSearch: =>
    $.get(@getSearchQuery(), @afterSearch)

  afterSearch: =>
    if @firstPage()
      @paginationTemplate.find("[data-type=previous]").addClass("disabled")
    else
      @paginationTemplate.find("[data-type=previous]").removeClass("disabled")

    if @lastPage()
      @paginationTemplate.find("[data-type=next]").addClass("disabled") 
    else
      @paginationTemplate.find("[data-type=next]").removeClass("disabled") 

  getSearchQuery: ->
    if @form.parents(".bookingsync-rentals-list").length > 0
      fieldName = "rentals_search"
    else
      fieldName = "remote_rentals_search"
    searchParams = "#{fieldName}[query]=#{@input.val()}&#{fieldName}[page]=#{@currentPage()}"
    "#{document.location.href}.js?#{searchParams}"

  goToPreviousPage: (e) =>
    e.preventDefault()
    return if @firstPage()
    $(@form).data("current-page", @currentPage() - 1)
    @displayWaiting()
    @backendSearch()
    
   goToNextPage: (e) =>
    e.preventDefault()
    return if @lastPage()
    $(@form).data("current-page", @currentPage() + 1)
    @displayWaiting()
    @backendSearch()

class @ListBackedFilter
  constructor: (header, list, @listElement, @listFilterable, @inputId, formTemplate, paginationTemplate) ->
    @header = $(header)
    @list = $(list)
    @form = $(formTemplate)
    @insertForm()
    @observeFormChanges()
    
    @paginationTemplate ||= $(HandlebarsTemplates["pagination"]())
    @insertPagination()
    @observePageChanges()

    @loadingTemplate = $(HandlebarsTemplates["loading"]()) 

    @doneTypingInterval = 1500 # 1.5 seconds wait after each keyup before sending search request
    @typingTimer = undefined

    @currentSearchQuery = @form.serialize()

  insertForm: ->
    @form.appendTo(@header)
    @input = $("#" + @inputId)

  insertPagination: ->
    @paginationTemplate.find("[data-type=previous]").addClass("disabled")
    @setPage(1)
    $(@paginationTemplate).appendTo(@list.parent())
    @refreshPagination()

  refreshPagination: ->
    if @firstPage()
      @paginationTemplate.find("[data-type=previous]").addClass("disabled")
    else
      @paginationTemplate.find("[data-type=previous]").removeClass("disabled")

    if @lastPage()
      @paginationTemplate.find("[data-type=next]").addClass("disabled") 
    else
      @paginationTemplate.find("[data-type=next]").removeClass("disabled") 

  setPage: (page)->
    $(@form).data("current-page", page)

  currentPage: ->
    $(@form).data("current-page")

  firstPage: ->
    @currentPage() == 1

  lastPage: ->
    $(".bookingsync-rentals-list").find(".panel").length < $("body").data("items-per-page")
    if @form.parents(".bookingsync-rentals-list").length > 0
      itemsCount = $("body").data("rentals-records-count")
    else
      itemsCount = $("body").data("remote-rentals-records-count")
    parseInt(itemsCount) < $("body").data("items-per-page")

  observeFormChanges: ->
    @input.on 'keyup', (e) =>
      @startSearching()

    @input.on 'change', =>
      @startSearching()

    @form.on 'change', (e) =>
      @startSearching()

  startSearching: =>
    return if @currentSearchQuery == @form.serialize()
    @currentSearchQuery = @form.serialize()
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
    @refreshPagination()

  getSearchQuery: ->
    if @form.parents(".bookingsync-rentals-list").length > 0
      fieldName = "rentals_search"
    else
      fieldName = "remote_rentals_search"
    searchParams = ["#{fieldName}[page]=#{@currentPage()}"]
    $(@form.serialize().split("&")).each (_, item) ->
      key = item.split("=")[0]
      value = item.split("=")[1]
      searchParams.push("#{fieldName}[#{key}]=#{value}")
      
    "#{document.location.href}.js?#{searchParams.join("&")}"

  goToPreviousPage: (e) =>
    e.preventDefault()
    return if @firstPage()
    $(@form).data("current-page", @currentPage() - 1)
    @displayWaiting()
    clearTimeout(@typingTimer)
    @backendSearch()
    
   goToNextPage: (e) =>
    e.preventDefault()
    return if @lastPage()
    $(@form).data("current-page", @currentPage() + 1)
    @displayWaiting()
    clearTimeout(@typingTimer)
    @backendSearch()

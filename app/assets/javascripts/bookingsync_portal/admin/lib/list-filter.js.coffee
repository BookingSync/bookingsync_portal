class @ListFilter
  constructor: (header, list, @listElement, @listFilterable, @inputId, formTemplate) ->
    @header = $(header)
    @list = $(list)
    @form = $(formTemplate)

    @insertForm()
    @observeInputChanges()

  insertForm: ->
    @form.appendTo(@header)
    @input = $("#" + @inputId)

  observeInputChanges: ->
    @input.change( =>
      filter = $(event.target).val()
      @showElements @listFilterable + ":not(:Contains(" + filter + "))"
      @hideElements @listFilterable + ":Contains(" + filter + ")"
      false
    ).keyup =>
      # fire the above change event after every letter
      @input.change()

  showElements: (elements) ->
    @list.find(elements).parents(@listElement).slideUp()

  hideElements: (elements) ->
    @list.find(elements).parents(@listElement).slideDown()

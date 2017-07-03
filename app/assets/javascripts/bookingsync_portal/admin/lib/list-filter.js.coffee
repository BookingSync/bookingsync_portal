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
      @hideElements @listFilterable + ":not(:Contains(" + filter + "))"
      @showElements @listFilterable + ":Contains(" + filter + ")"
      false
    ).keyup =>
      # fire the above change event after every letter
      @input.change()

  showElements: (elements) ->
    @list.find(elements).parents(@listElement).show()

  hideElements: (elements) ->
    @list.find(elements).parents(@listElement).hide()

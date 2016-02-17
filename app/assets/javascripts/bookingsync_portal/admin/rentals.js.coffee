$ ->
  for rentalsList, index in $(".rentals-list")
    inputId = "rentals-list-filter-#{index}"
    new ListFilter(
      $(rentalsList).children(".rentals-list-header"),
      $(rentalsList).children(".rentals-list-scroll"),
      ".panel",
      ".panel h4",
      inputId,
      HandlebarsTemplates["filter_input"]
        inputId: inputId
    )

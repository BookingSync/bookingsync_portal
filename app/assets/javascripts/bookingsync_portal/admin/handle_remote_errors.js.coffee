$ ->
  $(document).on "ajax:error", "[data-remote]", (e, xhr) ->
    location.reload() if xhr.status == 401

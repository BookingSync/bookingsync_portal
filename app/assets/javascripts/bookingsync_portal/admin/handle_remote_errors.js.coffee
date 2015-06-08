$ ->
  $(document).ajaxError (e, xhr) ->
    location.reload() if xhr.status == 401

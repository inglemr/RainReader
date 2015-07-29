$ ->
  $(".alert, .alert-notice").on("click", (event)->
    $(event.target).hide("slow")
  )

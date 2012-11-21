$ = jQuery

App.general = ->

  # tooltips & popovers

  $('a, input[type="submit"], button').filter('[title]').tooltip
    animation: false
    placement: 'top'
    container: 'body'

  $('input[data-content]').popover
    html: true
    trigger: 'focus'

  # dropdowns

  $('.dropdown.hover')
    .on 'mouseenter', ->
      unless $(@).hasClass('open')
        $(@).find('.dropdown-toggle')
          .dropdown('toggle')

    .on 'mouseleave', ->
      if $(@).hasClass('open')
        $(@).find('.dropdown-toggle')
          .dropdown('toggle')
          .blur()

  # modals

  $(document).on 'click', '.modal_close', (event) ->
    event.preventDefault()
    $(@).closest('.modal').modal('hide').remove()

  $(document).on 'click', '.delete_item', (event) ->
    event.preventDefault()
    $.modalAjax
      url: @href

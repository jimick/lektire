$ = jQuery

App.Questions.choice = module = {}

module.new = ($form) ->

  $options      = $('li', $form)
  $firstOption  = $options.first()
  $otherOptions = $firstOption.siblings()
  $template     = $firstOption.clone()

  $addButton    = $.addButton.clone()
  $removeButton = $.removeButton.clone()

  updateAttrs   = ($el, i) ->

    $input = $el.find 'input'

    i += 2

    id = $input.attr('id')
    placeholder = $input.attr('placeholder')

    $input.attr 'id',           id.replace(/\d+/, i)
    $input.attr 'placeholder',  placeholder.replace(/\d+/, i)

  addOption = ($el) ->
    $otherOptions = $otherOptions.add $el.insertBefore($addButton)

  removeOption = ($el) ->
    $otherOptions = $otherOptions.not $el.fadeOut('fast', -> $(@).remove())

  filled = ($el) ->
    result = true
    $el.find('input').each -> result = result and !!$(@).val()
    result

  $otherOptions.add($template).find('input').after $removeButton.clone()

  $template
    .find('input').val('').end()
    .find('div').removeClass('field_with_hint field_with_errors').end()
    .find('.hint, .error').remove()

  $addButton
    .insertAfter($otherOptions.last())
    .on 'click', ->
      $new = $template.clone()
      updateAttrs $new, $otherOptions.length
      addOption $new

  $form.on 'click', '.remove', ->
    $el = $(@).closest('li')
    removeOption $el
    $otherOptions.each (i) -> updateAttrs $(@), i

module.edit = ($form) ->

  module.new($form)

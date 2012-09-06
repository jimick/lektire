Lektire.Initializers.games = ->

  switch $('body').attr('class').split(' ')[1]

    when 'new'

      $form     = $('form')
      $quizzes  = $form.find '.quizzes'
      $players  = $form.find '.players'
      $login    = $form.find '.login'
      $controls = $form.find '.controls'

      $plural   = $controls.find '.plural'
      $name     = $controls.find '.name'

      $players.hide()
      $login.hide()
      $controls.hide()

      $quizzes.on 'click', ':radio', ->
        $players.show()
        $controls.show()
        $name.text $(@).next().text()

      $players.on 'click', ':radio', ->
        switch $(@).val()
          when '1'
            $login.hide()
            $login.find('input').val ''
            $plural.text ''
          when '2'
            $login.show()
            $plural.text 'te'

    when 'edit'

      # association

      conversion = (el) ->
        result = el.clone()
        result.find('input').each -> $(@).replaceWith($(@).val())
        el.after(result)
        el.hide()
        result

      $form             = $('form.association')

      $static           = {}
      $interactive      = {}

      $static.old       = $form.find('.static')
      $static.new       = conversion($static.old)

      $interactive.old  = $form.find('.interactive')
      $interactive.new  = conversion($interactive.old)

      $interactive.new.sortable
        placeholder: 'placeholder'
        forcePlaceholderSize: true
        tolerance: 'pointer'
        update: ->
          $old = $interactive.old.find 'input'
          $new = $interactive.new.find 'li'

          $old.each (i) -> $(@).val $new.eq(i).text()

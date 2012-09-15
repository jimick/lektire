$ = jQuery

Lektire.Controllers.games = (bodyClass) ->

  if bodyClass.search(/new|create/) isnt -1

    $form           = $('form')

    $sections       = $form.find('section')

    $quizzes        = $sections.filter '.quizzes'
    $players        = $sections.filter '.players'
    $login          = $sections.filter '.login'

    $buttons        = $form.find '.buttons'
    $button         = $buttons.find 'button'
    $quizName       = $buttons.find '.name'

    $quizzesChecked = $quizzes.find ':checked'
    $playersChecked = $players.find ':checked'

    setQuizName     = (name) -> $quizName.text(" #{name}")
    setPlural       = -> $button.html $button.html().replace(/Započni\b/, 'Započnite')
    setSingular     = -> $button.html $button.html().replace(/Započnite/, 'Započni')

    if not $quizzesChecked.length
      $players.hide()
      $login.hide()
      $buttons.hide()
    else
      setQuizName $quizzesChecked.next().text()
      setPlural() if $playersChecked.val() is '2'

    $quizzes.on 'click', ':radio', ->
      $players.show()
      setQuizName $(@).next().text()

    $players.on 'click', ':radio', ->
      $buttons.show()
      switch $(@).val()
        when '1'
          $login.hide()
          setSingular()
        when '2'
          $login.show()
          setPlural()

  if bodyClass.search(/show/) isnt -1

    delay = 500

    $('.score li').each ->

      $rank     = $(@).find '.rank'
      $label    = $(@).find '.label'
      $fill     = $(@).find '.fill'

      width     = $fill.css 'width'

      update    = ->

        currentWidth = parseFloat $fill.width()
        percentage = currentWidth / $label.width() * 100

        if currentWidth then $label.text "#{Math.round(percentage)}%" else $label.text "0%"

      $rank.hide()
      $fill.hide()

      $fill.css 'width', '0%'

      update()

      if width?
        window.setTimeout ->
          $fill.show().animate
            width     : width
          ,
            duration  : 2000
            easing    : 'easeOutCubic'
            step      : update
            complete  : -> $rank.fadeIn 'fast'
        , delay

        delay += 2000
      else
        window.setTimeout ->
          $rank.fadeIn 'fast'
        , delay
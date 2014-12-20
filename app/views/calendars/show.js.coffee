$ ->
  $cal5374 = $('.cal5374')
  $cal5374.text($cal5374.data('title'))

  url = $('.cal5374').attr('href')
  $("#select_area").change ->
    if +$(this).find("option:selected").val() == -1
      href = url
    else
      ics = $cal5374.data('ics')
      params =
        site: $cal5374.data('site') || document.location.href
        area: $(this).find("option:selected").text()
      query = $.param(params)
      href = "#{ics}?#{query}"
    $cal5374.attr(href: href)

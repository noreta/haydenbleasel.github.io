$ ->

    # Create abc,def string
    Number::numberWithCommas =
    String::numberWithCommas = ->
        @toString().replace /\B(?=(\d{3})+(?!\d))/g, ','

    # Geocoordinate directions (N/S/E/W)
    Number::direction =
    String::direction = (type) ->
        coordinate = parseInt(this)
        abs = Math.abs(coordinate)
        long = type == 'long'
        suffix = if abs < 0 then (if long then 'W' else 'S') else if long then 'E' else 'N'
        return abs + suffix

    # Instantiate FastClick
    FastClick.attach document.body

    # Wow...
    new WOW().init()

    # Refresh the resolution tag
    setInterval (->
        pixels = $(document).width() * $(document).height()
        $('#resolution').text pixels.numberWithCommas()
    ), 1000

    # Mobile menu toggle
    $('#menu').click ->
        $('body').toggleClass 'active'

$ ->

    # Create abc,def string
    String::numberWithCommas = ->
        @replace /\B(?=(\d{3})+(?!\d))/g, ','

    # Empty resize timer on page load
    resizeTimer = undefined

    # Set the page resolution field
    resolution = ->
        pixels = $(window).width() * $(window).height()
        $('#resolution').text pixels.toString().numberWithCommas()
        return

    # Detect window resizes (throttle for performance)
    $(window).resize ->
        clearTimeout resizeTimer
        resizeTimer = setTimeout(resolution, 250)
        return

    resolution()
    return

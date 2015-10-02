$ ->

    # Create abc,def string
    Number::numberWithCommas =
    String::numberWithCommas = ->
        @toString().replace /\B(?=(\d{3})+(?!\d))/g, ','

    # Instantiate FastClick
    FastClick.attach document.body

    # Empty resize timer on page load
    resizeTimer = undefined

    # Set the page resolution field
    resolution = ->
        pixels = $(document).width() * $(document).height()
        $('#resolution').text pixels.numberWithCommas()

    # Detect window resizes (throttle for performance)
    $(window).resize ->
        clearTimeout resizeTimer
        resizeTimer = setTimeout(resolution, 250)

    resolution()

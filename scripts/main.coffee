$ ->

    # Create abc,def string
    Number::numberWithCommas =
    String::numberWithCommas = ->
        @toString().replace /\B(?=(\d{3})+(?!\d))/g, ','

    # Create timeAgo string
    String::timeAgo = ->
        date = @toString()
        seconds = Math.floor((new Date - date) / 1000)
        interval = Math.floor(seconds / 31536000)
        if interval > 1
            return interval + ' years'
        interval = Math.floor(seconds / 2592000)
        if interval > 1
            return interval + ' months'
        interval = Math.floor(seconds / 86400)
        if interval > 1
            return interval + ' days'
        interval = Math.floor(seconds / 3600)
        if interval > 1
            return interval + ' hours'
        interval = Math.floor(seconds / 60)
        if interval > 1
            return interval + ' minutes'
        return Math.floor(seconds) + ' seconds'

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

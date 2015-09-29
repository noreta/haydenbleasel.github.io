$ ->

    client_id = '946beb26280ea30b9938fdf88b34a869'
    sound = undefined
    play = $('#play')
    pause = $('#pause')
    next = $('#next')
    prev = $('#prev')

    howl = (track) ->
        if (sound)
            sound.stop()
        track.addClass('playing').siblings().removeClass 'playing'
        $('#cover').attr 'src', track.data('cover')
        sound = new Howl(
            buffer: true
            format: track.data 'format'
            urls: [ track.attr('href') + '?client_id=' + client_id ]
            onpause: ->
                pause.hide(0)
                play.show(0)
            onplay: ->
                pause.show(0)
                play.hide(0)
            onend: ->
                track = $('.track.playing').next('.track')
                howl(track)
        ).play()

    $.getJSON 'http://api.soundcloud.com/playlists/116598264', {
        'client_id': client_id
    }, (playlist) ->
        $.each playlist.tracks, (index, track) ->
            if (track.streamable)
                $('#playlist').append [
                    '<a class="track" href="' + track.stream_url + '" data-format="' + track.original_format + '" data-cover="' + track.artwork_url + '">'
                    '<span class="index">' + (index + 1) + '</span>'
                    '<span class="title">' + track.title + '</span>'
                    '<span class="plays">' + track.playback_count.numberWithCommas() + '</span>'
                    '</a>'
                ].join('')

    $('#playlist').on 'click', '.track', (e) ->
        e.preventDefault()
        howl($(this))

    play.click ->
        sound.play()

    pause.click ->
        sound.pause()

    prev.click ->
        track = $('.track.playing').prev('.track')
        howl(track)

    next.click ->
        track = $('.track.playing').next('.track')
        howl(track)

    setInterval (->
        if (sound)
            val = (sound.pos() / sound._duration * 100)
            $('#progress').attr 'value', val
    ), 100

    $('#music').affix offset: top: ->
        $('header').outerHeight() - $(window).outerHeight() + $('#controls').outerHeight()

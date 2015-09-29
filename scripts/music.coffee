$ ->

    client_id = '946beb26280ea30b9938fdf88b34a869'
    sound = undefined

    $.getJSON 'http://api.soundcloud.com/playlists/116598264', {
        'client_id': client_id
    }, (playlist) ->
        console.log playlist
        $.each playlist.tracks, (index, track) ->
            if (track.streamable)
                $('#playlist').append [
                    '<a class="track" href="' + track.stream_url + '" data-format="' + track.original_format + '">'
                    '<span class="index">' + index + '</span>'
                    '<span class="title">' + track.title + '</span>'
                    '<span class="plays">' + track.playback_count.numberWithCommas() + '</span>'
                    '</a>'
                ].join('')
        return

    $('#playlist').on 'click', '.track', (e) ->
        e.preventDefault()
        self = $(this)
        self
            .addClass('playing')
            .siblings()
            .removeClass 'playing'
        if (sound)
            sound.stop()
        sound = new Howl(
            buffer: true
            format: self.data 'format'
            urls: [ self.attr('href') + '?client_id=' + client_id ]
        ).play()
        return

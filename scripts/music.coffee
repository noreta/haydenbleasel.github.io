# remove howler.js, use Soundcloud JS SDK (streaming fixes + built-in audio system)

$ ->

    # Initial sound is empty
    sound = undefined

    # Pause the current song
    pause = ->
        if (sound)
            sound.pause()
        $('#pause').hide 0
        $('#play').show 0

    # Play the song ID
    play = (id) ->
        $('#play').hide 0
        $('#pause').show 0

        if (id)
            if (sound)
                sound.stop()
            $('#progress').attr 'value', 0
            self = $('.track[data-id="' + id + '"]')
            $('.track').removeClass 'playing'
            self.addClass 'playing'
            $('#cover').attr 'src', self.data('cover')
            SC.stream '/tracks/' + id, (track) ->
                sound = track
                sound.play()
        else if (sound)
            sound.play()
        else
            play $('#playlist .track').first().data 'id'

    # Initialise the SoundCloud SDK
    SC.initialize(
        client_id: '946beb26280ea30b9938fdf88b34a869'
        redirect_uri: '?'
    )

    # Get my selected playlist
    SC.get '/playlists/116598264', (playlist) ->

        # Display the playlist
        $.each playlist.tracks, (index, track) ->
            if (track.streamable)
                $('#playlist').append [
                    '<div class="track wow fadeIn" data-wow-delay="' + index / 20 + 's" data-id="' + track.id + '" data-format="' + track.original_format + '" data-cover="' + track.artwork_url + '">'
                    '<span class="index">' + (index + 1) + '</span>'
                    '<span class="title">' + track.user.username + ' - ' + track.title + '</span>'
                    '<span class="plays">' + track.playback_count.numberWithCommas() + '</span>'
                    '</div>'
                ].join('')

        # Play button handler
        $('#play').click ->
            play()

        # Pause button handler
        $('#pause').click ->
            pause()

        # Previous button handler
        $('#prev').click ->
            play $('.playing').prev('.track').data('id')

        # Next button handler
        $('#next').click ->
            play $('.playing').next('.track').data('id')

    # Play the song that's clicked
    $('#playlist').on 'click', '.track', ->
        play $(this).data 'id'

    # Update the progress bar
    setInterval (->
        if (sound && sound._player && sound._player._currentPosition && sound._player._duration)
            $('#progress').attr 'value', (sound._player._currentPosition / sound._player._duration * 100)
            if (sound._player._currentPosition == sound._player._duration)
                play $('.playing').next('.track').data('id')

    ), 200

    # Affix the controls bar
    $('#music').affix offset: top: $('#controls').offset().top - 81

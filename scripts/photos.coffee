$ ->

    library = []

    loadImages = (url, callback) ->
        $.ajax
            url: url
            data: {
                count: 50
                access_token: '2047353728.75c688d.ac058af6b2cf44b6a0b491636a3a3eaa'
            }
            crossDomain: true
            dataType: 'jsonp'
            success: (photos, textStatus, errorThrown) ->
                library = library.concat photos.data
                $.each photos.data, (index, photo) ->
                    $('#instagram').append [
                        '<a class="photo" href="' + photo.link + '">'
                        '<img src="' + photo.images.standard_resolution.url + '" alt="' + photo.caption.text + '" width="640" height="640" />'
                        '</a>'
                    ].join('')
                if (photos.pagination and photos.pagination.next_url)
                    return loadImages(photos.pagination.next_url, callback)
                else
                    return callback()
            error: (jqXHR, textStatus, errorThrown) ->
                console.log 'Failed!'

    loadImages 'https://api.instagram.com/v1/users/2047353728/media/recent/', ->
        photomap = new Photomap(
            elementID: 'photomap'
            instagram: library
        )
        return

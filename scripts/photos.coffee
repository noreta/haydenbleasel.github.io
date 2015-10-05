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
                        '<div class="col-lg-3 col-md-4 col-sm-6 col-xs-12">'
                            '<a class="photo image-overlay wow fadeIn" href="' + photo.link + '" data-wow-delay="' + (index % 4 / 5) + 's">'
                                '<img src="' + photo.images.standard_resolution.url + '" alt="' + photo.caption.text + '" width="640" height="640" />'
                                '<div class="overlay">'
                                    '<small>' + photo.location.name + ' (' + photo.location.latitude.direction() + ' × ' + photo.location.longitude.direction('long') + ')</small>'
                                    '<p>' + jEmoji.unifiedToHTML(photo.caption.text) + '</p>'
                                    '<div class="clearfix meta">'
                                        '<small class="pull-left"> <i class="fa fa-heart"></i>' + photo.likes.count + '</small>'
                                        '<small class="pull-right date">' + moment.unix(photo.caption.created_time).fromNow() + '</small>'
                                    '</div>'
                                '</div>'
                            '</a>'
                        '</div>'
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
            theme: [
                {
                    'featureType': 'all'
                    'elementType': 'labels'
                    'stylers': [ { 'lightness': '0' } ]
                }
                {
                    'featureType': 'all'
                    'elementType': 'labels.text.fill'
                    'stylers': [
                        { 'saturation': 36 }
                        { 'color': '#bbbbbb' }
                        { 'lightness': 40 }
                    ]
                }
                {
                    'featureType': 'all'
                    'elementType': 'labels.text.stroke'
                    'stylers': [
                        { 'visibility': 'on' }
                        { 'color': '#ffffff' }
                        { 'lightness': 16 }
                    ]
                }
                {
                    'featureType': 'all'
                    'elementType': 'labels.icon'
                    'stylers': [ { 'visibility': 'off' } ]
                }
                {
                    'featureType': 'administrative'
                    'elementType': 'geometry.fill'
                    'stylers': [
                        { 'color': '#fefefe' }
                        { 'lightness': 20 }
                    ]
                }
                {
                    'featureType': 'administrative'
                    'elementType': 'geometry.stroke'
                    'stylers': [
                        { 'color': '#fefefe' }
                        { 'lightness': 17 }
                        { 'weight': 1.2 }
                    ]
                }
                {
                    'featureType': 'landscape'
                    'elementType': 'geometry'
                    'stylers': [
                        { 'color': '#f5f5f5' }
                        { 'lightness': 20 }
                    ]
                }
                {
                    'featureType': 'poi'
                    'elementType': 'geometry'
                    'stylers': [
                        { 'color': '#f5f5f5' }
                        { 'lightness': 21 }
                    ]
                }
                {
                    'featureType': 'poi.park'
                    'elementType': 'geometry'
                    'stylers': [
                        { 'color': '#dedede' }
                        { 'lightness': 21 }
                    ]
                }
                {
                    'featureType': 'road.highway'
                    'elementType': 'geometry.fill'
                    'stylers': [
                        { 'color': '#ffffff' }
                        { 'lightness': 17 }
                    ]
                }
                {
                    'featureType': 'road.highway'
                    'elementType': 'geometry.stroke'
                    'stylers': [
                        { 'color': '#ffffff' }
                        { 'lightness': 29 }
                        { 'weight': 0.2 }
                    ]
                }
                {
                    'featureType': 'road.arterial'
                    'elementType': 'geometry'
                    'stylers': [
                        { 'color': '#ffffff' }
                        { 'lightness': 18 }
                    ]
                }
                {
                    'featureType': 'road.local'
                    'elementType': 'geometry'
                    'stylers': [
                        { 'color': '#ffffff' }
                        { 'lightness': 16 }
                    ]
                }
                {
                    'featureType': 'transit'
                    'elementType': 'geometry'
                    'stylers': [
                        { 'color': '#f2f2f2' }
                        { 'lightness': 19 }
                    ]
                }
                {
                    'featureType': 'water'
                    'elementType': 'geometry'
                    'stylers': [
                        { 'color': '#e9e9e9' }
                        { 'lightness': 17 }
                    ]
                }
            ]
        )
        return

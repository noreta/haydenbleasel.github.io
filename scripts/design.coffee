$ ->
    $.getJSON 'https://api.dribbble.com/v1/users/haydenbleasel/shots', {
        'access_token': 'c6bbfa0a498b17619993ae7681d21c04eb108ce3251e7e2d7cecb38ff53195ab',
        'per_page': 100
    }, (shots) ->
        $.each shots, (index, shot) ->
            description = $(shot.description)
            $('a', description).contents().unwrap()
            $('#grid').append [
                '<div class="col-md-4 col-sm-6 col-xs-12">'
                    '<a class="shot image-overlay wow fadeIn" href="' + shot.html_url + '" data-wow-delay="' + (index % 3 / 5) + 's">'
                        '<img src="' + shot.images.hidpi + '" alt="' + shot.title + '" width="800" height="600" />'
                        '<div class="overlay">'
                            '<small>' + shot.title + '</small>'
                            '<p>' + jEmoji.unifiedToHTML(description.html()) + '</p>'
                            '<div class="clearfix meta">'
                                '<small class="pull-left"> <i class="fa fa-heart"></i>' + shot.likes_count + '</small>'
                                '<small class="pull-right date">' + moment(shot.created_at, moment.ISO_8601).fromNow() + '</small>'
                            '</div>'
                        '</div>'
                    '</a>'
                '</div>'
            ].join('')
        return
    return

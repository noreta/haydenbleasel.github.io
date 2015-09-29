$ ->
    $.getJSON 'https://api.dribbble.com/v1/users/haydenbleasel/shots', {
        'access_token': 'c6bbfa0a498b17619993ae7681d21c04eb108ce3251e7e2d7cecb38ff53195ab',
        'per_page': 100
    }, (shots) ->
        $.each shots, (index, shot) ->
            $('#grid').append [
                '<a class="shot" href="' + shot.html_url + '">'
                '<img src="' + shot.images.hidpi + '" alt="' + shot.title + '" width="800" height="600" />'
                '</a>'
            ].join('')
        return
    return

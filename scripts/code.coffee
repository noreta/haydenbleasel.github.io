$ ->

    $.getJSON 'https://api.github.com/users/haydenbleasel/repos', {
        'access_token': 'f305462cd1557500084f9aa7c2c993d2c8e6b12f',
        'callback': '?'
    }, (repos) ->

        console.log repos

        # Sort repositories by stars
        repos.data.sort (a, b) ->
            b.stargazers_count - a.stargazers_count

        $.each repos, (index, repo) ->
            if !repo.fork
                $('#repositories').append [
                    '<tr>'
                    '<td>' + repo.name + '</td>'
                    '<td>' + repo.stargazers_count + '</td>'
                    '</tr>'
                ].join('')
        return
    return

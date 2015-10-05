$ ->

    # Fetch GitHub repositories
    $.ajax
        url: 'https://api.github.com/users/haydenbleasel/repos'
        data: {
            access_token: 'f305462cd1557500084f9aa7c2c993d2c8e6b12f'
        }
        crossDomain: true
        dataType: 'jsonp'
        success: (repos) ->
            repos.data.sort (a, b) ->
                b.stargazers_count - a.stargazers_count
            $.each repos.data, (index, repo) ->
                if (!repo.fork and repo.name != 'haydenbleasel.github.io')
                    $('#repositories tbody').append [
                        '<tr class="wow fadeIn" data-wow-delay="' + index / 20 + 's">'
                            '<td> <a href="' + repo.html_url + '">' + repo.name + '</a> </td>'
                            '<td>' + repo.stargazers_count + '</td>'
                            '<td>' + repo.forks + '</td>'
                        '</tr>'
                    ].join('')

    # Fetch GitHub activity feed
    $.ajax
        url: 'https://api.github.com/users/haydenbleasel/events'
        data: {
            access_token: 'f305462cd1557500084f9aa7c2c993d2c8e6b12f'
        }
        crossDomain: true
        dataType: 'jsonp'
        success: (events) ->

            messages = []

            $.each events.data, (index, event) ->

                message = (
                    content: [event.actor.login]
                    date: moment(event.created_at, moment.ISO_8601).fromNow()
                )

                switch event.type
                    when 'CommitCommentEvent'
                        message.content.push 'commented on a commit for'
                    when 'CreateEvent'
                        message.content.push 'created'
                    when 'DeleteEvent'
                        message.content.push 'deleted the'
                        message.content.push event.ref_type
                        message.content.push '"' + event.ref '"'
                        message.content.push 'on'
                    when 'ForkEvent'
                        message.content.push 'forked'
                    when 'GollumEvent'
                        message.content.push 'updated the wiki for'
                    when 'IssueCommentEvent'
                        message.content.push 'commented on an issue for'
                    when 'IssuesEvent'
                        message.content.push 'updated an issue for'
                    when 'MemberEvent'
                        message.content.push 'was added as a collaborator to'
                    when 'PublicEvent'
                        message.content.push 'open sourced'
                    when 'PullRequestEvent'
                        message.content.push 'updated a pull request for'
                    when 'PullRequestReviewCommentEvent'
                        message.content.push 'commented on a pull request for'
                    when 'PushEvent'
                        message.content.push 'pushed changes to'
                    when 'ReleaseEvent'
                        message.content.push 'released a new version of'
                    when 'WatchEvent'
                        message.content.push 'starred'
                    else
                        break

                message.content.push event.repo.name.split('/')[1]

                if (!messages.length || message.content.join(' ') != messages[messages.length - 1].content.join(' '))
                    messages.push message

            $.each messages, (index, message) ->
                $('#activity tbody').append [
                    '<tr class="wow fadeIn" data-wow-delay="' + index / 20 + 's">'
                        '<td>' + message.content.join(' ') + ' ' + message.date + '</a> </td>'
                    '</tr>'
                ].join('')

    $.ajax
        url: 'https://api.github.com/users/haydenbleasel/gists'
        data: {
            access_token: 'f305462cd1557500084f9aa7c2c993d2c8e6b12f'
        }
        crossDomain: true
        dataType: 'jsonp'
        success: (gists) ->

            console.log gists

            $.each gists.data, (index, gist) ->
                $('#gists tbody').append [
                    '<tr class="wow fadeIn" data-wow-delay="' + index / 20 + 's">'
                        '<td> <a href="' + gist.html_url + '">' + Object.keys(gist.files)[0] + '</a> — ' + gist.description + '</td>'
                    '</tr>'
                ].join('')

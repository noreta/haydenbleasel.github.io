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
                        '<tr>'
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

            $.each events.data, (index, event) ->

                console.log event

                message = [event.actor.login]

                switch event.type
                    when 'CommitCommentEvent'
                        message.push 'commented on a commit for'
                        message.push event.repo.name
                    when 'CreateEvent'
                        message.push 'created'
                        message.push event.repo.name
                    when 'DeleteEvent'
                        message.push 'deleted the'
                        message.push event.ref_type
                        message.push event.ref
                        message.push 'on'
                        message.push event.repository.name
                    when 'DeploymentEvent'
                        message.push 'deployed'
                    when 'DeploymentStatusEvent'
                        message.push ''
                    when 'ForkEvent'
                        message.push 'forked'
                    when 'GollumEvent'
                        message.push 'updated the wiki for'
                    when 'IssueCommentEvent'
                        message.push 'commented on an issue for'
                    when 'IssuesEvent'
                        message.push 'updated an issue for'
                    when 'MemberEvent'
                        message.push 'was added as a collaborator to'
                    when 'MembershipEvent'
                        message.push 'was added as a member to'
                    when 'PageBuildEvent'
                        message.push ''
                    when 'PublicEvent'
                        message.push ''
                    when 'PullRequestEvent'
                        message.push ''
                    when 'PullRequestReviewCommentEvent'
                        message.push ''
                    when 'PushEvent'
                        message.push 'pushed changes to'
                    when 'ReleaseEvent'
                        message.push ''
                    when 'RepositoryEvent'
                        message.push ''
                    when 'StatusEvent'
                        message.push ''
                    when 'TeamAddEvent'
                        message.push ''
                    when 'WatchEvent'
                        message.push 'starred'
                    else
                        break


                if event.repo
                    message.push event.repo.name
                else if event.team
                    message.push event.team.name


                message.push event.repo.name
                message.push event.created_at.timeAgo()

                console.log message

                $('#activity tbody').append [
                    '<tr>'
                    '<td> <a href="' + event.repo.url + '">' + message.join(' ') + '</a> </td>'
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
                    '<tr>'
                    '<td> <a href="' + gist.html_url + '">' + Object.keys(gist.files)[0] + '</a> </td>'
                    '</tr>'
                ].join('')

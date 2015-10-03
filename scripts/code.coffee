$ ->

    $.ajax
        url: 'https://api.github.com/users/haydenbleasel/repos'
        data: {
            access_token: 'f305462cd1557500084f9aa7c2c993d2c8e6b12f'
        }
        crossDomain: true
        dataType: 'jsonp'
        success: (repos) ->

            # Sort repositories by stars
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

    $.ajax
        url: 'https://api.github.com/users/haydenbleasel/events'
        data: {
            access_token: 'f305462cd1557500084f9aa7c2c993d2c8e6b12f'
        }
        crossDomain: true
        dataType: 'jsonp'
        success: (events) ->

            console.log events

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





# $ ->
#
#
#     # Extend Chart configuration
#     $.extend Chart.defaults.global,
#         tooltipFillColor: 'rgba(24, 24, 25, 0.8)'
#         tooltipFontSize: 13
#         tooltipYPadding: 10
#         tooltipXPadding: 10
#         tooltipTemplate: '<%=label%>: <%= value %> stars'
#
#     # Time for some async
#     async.parallel [
#
#     # After all parallel tasks are complete...
#     ], (err) ->
#
#         # Create repository chart
#         chart = $('#canvas').get(0).getContext('2d')
#         barChart = new Chart(chart).Bar({
#             labels: repositories.labels
#             datasets: [ {
#                 label: 'Stargazers'
#                 fillColor: '#D8D9DC'
#                 strokeColor: '#D8D9DC'
#                 highlightFill: '#B0B2B9'
#                 highlightStroke: '#B0B2B9'
#                 data: repositories.data
#             } ]
#         }, showScale: false)
#
#         return
#
#     return

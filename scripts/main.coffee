$ ->

    # Create abc,def string
    Number::numberWithCommas =
    String::numberWithCommas = ->
        @toString().replace /\B(?=(\d{3})+(?!\d))/g, ','

# $ ->
#
#     # Variables
#     photo = '5HMh_VukYd'
#     instagram = '2047353728.75c688d.ac058af6b2cf44b6a0b491636a3a3eaa'
#     github = 'f305462cd1557500084f9aa7c2c993d2c8e6b12f'
#     repositories =
#         labels: []
#         data: []
#
#     # Instantiate FastClick
#     FastClick.attach document.body
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
#         # Pull repository stats from GitHub
#         (callback) ->
#             $.getJSON 'https://api.github.com/users/haydenbleasel/repos?access_token=' + github + '&callback=?', (repos) ->
#
#                 # Sort repositories by stars
#                 repos.data.sort (a, b) ->
#                     b.stargazers_count - (a.stargazers_count)
#
#                 # Save 6 most popular source repositories
#                 async.each repos.data, ((repo, callback) ->
#                     if !repo.fork and repositories.labels.length < 6
#                         repositories.labels.push repo.name
#                         repositories.data.push repo.stargazers_count
#                     callback()
#                 ), (error) ->
#                     callback null
#                 return
#             return
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

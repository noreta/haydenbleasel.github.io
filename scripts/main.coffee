$ ->

    # Create abc,def string
    Number::numberWithCommas =
    String::numberWithCommas = ->
        @toString().replace /\B(?=(\d{3})+(?!\d))/g, ','

    # Instantiate FastClick
    FastClick.attach document.body

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

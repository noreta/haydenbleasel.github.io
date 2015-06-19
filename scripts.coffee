$ ->

    # Variables
    photo = '3xlPd7HNCu'
    instagram = '2047353728.75c688d.ac058af6b2cf44b6a0b491636a3a3eaa'
    github = 'f305462cd1557500084f9aa7c2c993d2c8e6b12f'
    repositories =
        labels: []
        data: []

    # Instantiate FastClick
    FastClick.attach document.body

    # Extend Chart configuration
    $.extend Chart.defaults.global,
        tooltipFillColor: 'rgba(24, 24, 25, 0.8)'
        tooltipFontSize: 13
        tooltipYPadding: 10
        tooltipXPadding: 10
        tooltipTemplate: '<%=label%>: <%= value %> stars'

    # Time for some async
    async.parallel [

        # Pull repository stats from GitHub
        (callback) ->
            $.getJSON 'https://api.github.com/users/haydenbleasel/repos?access_token=' + github + '&callback=?', (repos) ->

                # Sort repositories by stars
                repos.data.sort (a, b) ->
                    b.stargazers_count - (a.stargazers_count)

                # Save 6 most popular source repositories
                async.each repos.data, ((repo, callback) ->
                    if !repo.fork and repositories.labels.length < 6
                        repositories.labels.push repo.name
                        repositories.data.push repo.stargazers_count
                    callback()
                ), (error) ->
                    callback null
                return
            return

        # Pull specified shot from Instagram
        (callback) ->
            $.getJSON 'https://api.instagram.com/v1/media/shortcode/' + photo + '?access_token=' + instagram + '&callback=?', (media) ->
                $('#count').text media.data.likes.count
                $('#instagram').css 'background-image', 'url("' + media.data.images.standard_resolution.url + '")'
                $('#link').attr 'href', media.data.link
                callback null
            return

        # Execute FullPage.js
        (callback) ->
            $('#information').fullpage
                anchors: [
                    'hayden'
                    'career'
                    'education'
                    'design'
                    'code'
                ]
                navigation: true
                navigationPosition: 'right'
                navigationTooltips: [
                    'hayden'
                    'career'
                    'education'
                    'design'
                    'code'
                ]
                easingcss3: 'cubic-bezier(0.25, 0.46, 0.45, 0.94)'
                paddingTop: '60px'
                paddingBottom: '60px'
                sectionSelector: 'section'
                afterRender: ->
                    callback null
            return

    # After all parallel tasks are complete...
    ], (err) ->

        $('body').removeClass 'hidden'

        # Create repository chart
        chart = $('#canvas').get(0).getContext('2d')
        barChart = new Chart(chart).Bar({
            labels: repositories.labels
            datasets: [ {
                label: 'Stargazers'
                fillColor: '#D8D9DC'
                strokeColor: '#D8D9DC'
                highlightFill: '#B0B2B9'
                highlightStroke: '#B0B2B9'
                data: repositories.data
            } ]
        }, showScale: false)

        return

    return

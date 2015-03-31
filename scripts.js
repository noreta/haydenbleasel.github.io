/*jslint browser:true, unparam:true, newcap:true*/
/*global $, scrollReveal, async, FastClick*/

$(function () {

    // Strict mode
    'use strict';

    // Start ScrollReveal
    window.sr = new scrollReveal({
        vFactor:  0.4
    });

    // Start FastClick
    FastClick.attach(document.body);

    // Smooth scroll to internal links
    $('a[href*=#]:not([href=#])').click(function () {
        if (window.location.pathname.replace(/^\//, '') === this.pathname.replace(/^\//, '')  || window.location.hostname === this.hostname) {
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
            if (target.length) {
                $('#viewport').animate({
                    scrollTop: target.offset().top
                }, 1000);
                return false;
            }
        }
    });

    $.getJSON('https://api.github.com/users/haydenbleasel/repos?callback=?', function (repos) {
        var github = [], divisor;
        repos.data.sort(function (a, b) {
            return b.stargazers_count - a.stargazers_count;
        });
        $.each(repos.data, function (index, repo) {
            if (!repo.fork) {
                github.push([
                    '<p><a class="clearfix" href="' + repo.html_url + '">',
                    '<span class="pull-left">' + (repo.name === 'haydenbleasel.github.io' ? 'hydn.co' : repo.name) + '</span>',
                    '<span class="stars pull-right"><i class="icon-star"></i>' + repo.stargazers_count + '</span>',
                    '</a></p>'
                ].join(''));
            }
        });
        divisor = Math.ceil(github.length / 3);
        $('#github .col-sm-4').each(function (index) {
            $(this).append(github.slice(index * divisor, (index + 1) * divisor));
        });
    });

    $.getJSON("https://api.dribbble.com/v1/teams/sumry/shots", {
        access_token: 'c6bbfa0a498b17619993ae7681d21c04eb108ce3251e7e2d7cecb38ff53195ab',
        per_page: '100'
    }, function (shots) {
        $.each(shots, function (index, shot) {
            $('#dribbble').append('<div class="shot"><a href="' + shot.html_url + '"><img src="' + shot.images.hidpi + '" alt="' + shot.title + '" width="800" height="600" /></a></div>');
        });
    });

});

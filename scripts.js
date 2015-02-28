/*jslint unparam:true, devel:true*/
/*global $*/

$(function () {
    'use strict';

    $.getJSON('https://api.github.com/users/haydenbleasel/repos?callback=?', function (repos) {
        var repoNames = [];
        repos.data.sort(function (a, b) {
            return b.stargazers_count - a.stargazers_count;
        });
        $.each(repos.data, function (index, repo) {
            if (repo.fork) {
                $('#forks').append('<li><a href="' + repo.html_url + '">' + repo.name + '</a></li>');
            } else {
                $('#sources').append('<li><a class="clearfix" href="' + repo.html_url + '"><span class="float-left">' + repo.name + '</span><span class="float-right">' + repo.stargazers_count + ' ' + (repo.stargazers_count === 1 ? 'star' : 'stars') + '</span></a></li>');
                repoNames.push(repo.name.toLowerCase());
            }
        });
        $.getJSON("https://api.npmjs.org/downloads/point/last-month/" + repoNames.join(), function (modules) {
            var sortable = [];
            $.each(modules, function (index, mod) {
                sortable.push(mod);
            });
            sortable.sort(function (a, b) {
                return b.downloads - a.downloads;
            });
            $.each(sortable, function (index, mod) {
                $('#modules').append('<li><a class="clearfix" href="https://www.npmjs.com/package/' + mod.package + '"><span class="float-left">' + mod.package + '</span><span class="float-right">' + mod.downloads + ' DL/M</span></a></li>');
            });
        });
    });

    $.getJSON("https://api.dribbble.com/v1/users/haydenbleasel/shots", {
        access_token: 'c6bbfa0a498b17619993ae7681d21c04eb108ce3251e7e2d7cecb38ff53195ab',
        per_page: '100'
    }, function (shots) {
        $.each(shots, function (index, shot) {
            $('#dribbble').append('<div class="shot"><a href="' + shot.html_url + '"><img src="' + shot.images.hidpi + '" alt="' + shot.title + '" /></a></div>');
        });
    });

    $.getJSON("https://api.twitch.tv/kraken/streams/haydenbleasel?callback=?", function (data) {
        console.log(data); //stream = null or object if live
    });
});

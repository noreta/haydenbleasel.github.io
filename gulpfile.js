/*jslint node:true*/

(function () {

    'use strict';

    var gulp = require('gulp'),
        sync = require('browser-sync'),
        del = require('del'),
        $ = require('gulp-load-plugins')(),
        config = require('./package.json');

    gulp.task('clean', function (next) {
        return del('.tmp/', next);
    });

    gulp.task('jade', function () {
        return gulp.src('index.jade')
            .pipe($.jade({ pretty: true, locals: config }))
            .pipe(gulp.dest('./'))
            .pipe(sync.reload({ stream: true, once: true }));
    });

    gulp.task('compress', ['jade'], function () {
        return gulp.src('index.html')
            .pipe($.robots({ out: 'robots.txt' }))
            .pipe($.favicons({
                files: {
                    dest: './',
                    iconsPath: '/'
                },
                icons: {
                    appleStartup: false,
                    yandex: false
                },
                settings: {
                    background: '#00BD9C',
                    version: config.version,
                    index: 'index.html'
                }
            }))
            .pipe($.ga({ url: config.homepage, uid: 'UA-46564523-6' }))
            .pipe($.htmlmin({ collapseWhitespace: true, keepClosingSlash: true, minifyJS: true, minifyCSS: true }))
            .pipe(gulp.dest('./'))
            .pipe($.sitemap({ siteUrl: config.homepage }))
            .pipe(gulp.dest('./'));
    });

    gulp.task('default', ['clean'], function () {
        return gulp.start('compress');
    });

    gulp.task('browser-sync', ['jade'], function () {
        return sync.init({ server: {  baseDir: './' } });
    });

    gulp.task('preview', ['browser-sync'], function () {
        gulp.watch('index.jade', ['jade']);
    });

}());

/*jslint node:true*/

(function () {

    'use strict';

    var gulp = require('gulp'),
        path = require('path'),
        sync = require('browser-sync').create(),
        pagespeed = require('psi'),
        del = require('del'),
        yargs = require('yargs').argv,
        Pageres = require('pageres'),
        crawler = require('simplecrawler'),
        runSequence = require('run-sequence'),
        isOnline = require('is-online'),
        $ = require('gulp-load-plugins')(),
        config = require('./package.json'),
        header = '/*! Built with Catalyst. */',
        online = false;

    gulp.task('build:templates', function () {
        return gulp.src('index.jade')
            .pipe($.plumber())
            .pipe($.jade({ pretty: true, locals: config }))
            .pipe($.specialHtml())
            .pipe(gulp.dest('build/'));
    });

    gulp.task('build:scripts', function () {
        return gulp.src('scripts.coffee')
            .pipe($.plumber())
            .pipe($.coffeelint({
                indentation: { value: 4 },
                max_line_length: { value: 200 }
            }))
            .pipe($.coffeelint.reporter())
            .pipe($.coffee())
            .pipe($.stripDebug())
            .pipe($.uglify())
            .pipe($.header(header))
            .pipe(gulp.dest("build/"));
    });

    gulp.task('build:styles', function () {
        return gulp.src('styles.less')
            .pipe($.plumber())
            .pipe($.recess({
                strictPropertyOrder: false,
                noOverqualifying: false,
                noIDs: false
            }))
            .pipe($.recess.reporter())
            .pipe($.less())
            .pipe($.colorguard({ logOk: true }))
            .pipe($.header(header))
            .pipe($.autoprefixer())
            .pipe($.combineMediaQueries())
            .pipe($.csso())
            .pipe(gulp.dest('build/'))
            .pipe(sync.reload({ stream: true, once: true }));
    });

    gulp.task('bundle', function () {
        return gulp.src('build/index.html')
            .pipe($.robots({ out: 'robots.txt' }))
            .pipe($.humans({ header: 'hydn.co', out: 'humans.txt' }))
            .pipe($.injectString.before('</head>', '\n<meta name="apple-mobile-web-app-capable" content="yes" />'))
            .pipe($.injectString.before('</head>', '<link rel="favicons" href="logo.png">'))
            .pipe($.injectString.before('</head>', '<link rel="sitemap" href="' + path.join(config.homepage, 'sitemap.xml') + '">'))
            .pipe($.if(online, $.favicons({
                files: {
                    dest: './',
                    iconsPath: '/'
                },
                icons: {
                    appleStartup: false,
                    yandex: false
                },
                settings: {
                    background: '#FFFFFF',
                    version: config.version,
                    index: 'index.html'
                }
            })))
            .pipe($.inlineSource({ compress: false }))
            .pipe($.minifyInline())
            .pipe($.minifyHtml({ empty: true, spare: true, quotes: true }))
            .pipe(gulp.dest('./'))
            .pipe($.sitemap({ siteUrl: config.homepage }))
            .pipe(gulp.dest('./'));
    });

    gulp.task('copy', function () {
        return gulp.src(['build/**', '!build/{vendor,vendor/**}', '!build/*.html'])
            .pipe(gulp.dest('./'));
    });

    gulp.task('clean', function (callback) {
        return del([
            '*.{png,webapp,json,html,css,js,ico,txt,xml}', 'fonts/', '!gulpfile.js', '!package.json',
            'build/*', '!build/vendor', '!build/fonts', '!build/logo.png'
        ], callback);
    });

    gulp.task('browser-sync', function () {
        return sync.init({
            server: { baseDir: 'build/' },
            tunnel: true
        });
    });

    gulp.task('bump', function () {
        return gulp.src(['bower.json', 'package.json'])
            .pipe($.bump({ type: yargs.type }))
            .pipe(gulp.dest('./'));
    });

    gulp.task('check', ['refresh', 'browser-sync'], function () {
        sync.emitter.on('service:running', function (data) {
            crawler.crawl(data.tunnel)
                .on("fetchcomplete", function (link) {
                    $.util.log('Download successful: ' + link.url);
                })
                .on("fetcherror", function (link) {
                    $.util.log('Download unsuccessful: ' + link.url);
                })
                .on("complete", sync.exit);
        });
    });

    gulp.task('responsive', ['refresh', 'browser-sync'], function () {
        var resolutions = ['1920x1080', '1680x1050', '768x1024', '320x480'];
        if (resolutions.length > 0) {
            sync.emitter.on("service:running", function (data) {
                var pageres = new Pageres()
                    .src(data.tunnel, resolutions, { crop: true })
                    .dest('test/screenshots/');
                pageres.run(function (error) {
                    if (error) {
                        throw error;
                    }
                    $.util.log('Successfully created screenshots');
                    sync.exit();
                });
            });
        }
    });

    gulp.task('pagespeed', ['refresh', 'browser-sync'], function () {
        return sync.emitter.on("service:running", function (data) {
            pagespeed({ nokey: 'true', url: data.tunnel, strategy: yargs.type }, sync.exit);
        });
    });

    gulp.task('refresh', function (callback) {
        return isOnline(function (error, connection) {
            if (error) {
                throw error;
            }
            if (!connection) {
                $.util.log('NOTE: Internet connection is currently down, W3C.js and Favicons are suppressed.');
            }
            online = connection;
            runSequence(['build:templates', 'build:scripts', 'build:styles'], callback);
        });
    });

    gulp.task('preview', function (callback) {
        runSequence('refresh', 'browser-sync', callback);
        return gulp.watch(['index.jade', 'styles.less', 'scripts.coffee', 'gulpfile.js'], ['refresh']);
    });

    gulp.task('default', function (callback) {
        return runSequence('clean', 'refresh', 'bundle', 'copy', callback);
    });

}());

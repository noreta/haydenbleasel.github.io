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
        wiredep = require('wiredep').stream,
        $ = require('gulp-load-plugins')(),
        config = require('loadobjects').sync('config/'),
        info = require('./package.json'),
        header = '/*! Built with Catalyst. */',
        staticFiles = gulp.src([
            'build/**',
            '!build/{vendor,vendor/**}',
            '!build/*.html'
        ], { dot: true }),
        online = false;

    config.jade.locals = {
        description: info.description,
        homepage: info.homepage
    };
    config.sitemap.siteUrl = info.homepage;
    config.favicons.settings.version = info.version;
    config.bump.type = yargs.type;
    config.pagespeed.strategy = yargs.type;
    config.wiredep.bowerJson = require('./bower.json');

    gulp.task('build:copy', function () {
        $.util.log('No files to copy.');
        //staticFiles.pipe(gulp.dest('test/build/'));
    });

    gulp.task('build:templates', function () {
        gulp.src('index.jade')
            .pipe($.plumber())
            .pipe($.jade(config.jade))
            .pipe(wiredep(config.wiredep))
            .pipe($.specialHtml())
            //.pipe($.if(online, $.w3cjs()))
            .pipe(gulp.dest('build/'));
    });

    gulp.task('build:fonts', function () {
        gulp.src([])
            .pipe($.fontmin(config.fontmin))
            .pipe(gulp.dest('build/fonts'));
    });

    gulp.task('build:images', function () {
        gulp.src(['images/*', '!images/sprite-*'])
            .pipe($.plumber())
            .pipe($.imagemin())
            .pipe(gulp.dest('build/images/'));
    });

    gulp.task('build:sprites', function () {
        var sprites = gulp.src('images/sprite-*'), spriteData;
        sprites.on('readable', function () {
            spriteData = sprites.pipe($.spritesmith(config.spritesmith));
            spriteData.img.pipe(gulp.dest('build/images/'));
            spriteData.css.pipe(gulp.dest('build/concat/'));
        });
    });

    gulp.task('build:scripts', function () {
        gulp.src('scripts/*.coffee')
            .pipe($.plumber())
            .pipe($.concat('scripts.coffee'))
            .pipe($.coffeelint(config.coffeelint))
            .pipe($.coffeelint.reporter())
            .pipe($.coffee())
            .pipe($.complexity())
            .pipe(gulp.dest("build/"));
    });

    gulp.task('build:styles', function () {
        gulp.src(['styles/styles.less'])
            .pipe($.plumber())
            .pipe($.less())
            .pipe($.addSrc(['build/concat/*.css', 'build/fonts/*.css']))
            .pipe($.colorguard(config.colorguard))
            .pipe($.autoprefixer())
            .pipe($.recess(config.recess))
            .pipe($.recess.reporter())
            .pipe(gulp.dest('build/'))
            .pipe(sync.reload(config.browsersync));
    });

    gulp.task('dist:bundle', function () {
        var assets = $.useref.assets();
        gulp.src('build/index.html')
            .pipe($.robots(config.robots))
            .pipe($.humans(config.humans))
            //.pipe($.injectString.before('</head>', '\n<meta name="apple-mobile-web-app-capable" content="yes" />'))
            .pipe($.injectString.before('</head>', '<link rel="favicons" href="logo.png">'))
            .pipe($.if(online, $.favicons(config.favicons)))
            .pipe(assets)
            .pipe($.rev())
            .pipe(assets.restore())
            .pipe($.useref())
            .pipe($.revReplace())
            .pipe(gulp.dest('build/templates'));
    });

    gulp.task('dist:copy', function () {
        staticFiles.pipe(gulp.dest('./'));
    });

    gulp.task('dist:templates', function () {
        gulp.src('build/templates/index.html')
            .pipe($.injectString.before('</head>', '<link rel="sitemap" href="' + path.join(info.homepage, 'sitemap.xml') + '">'))
            .pipe($.inlineSource(config.inlinesource))
            .pipe($.minifyInline())
            .pipe($.minifyHtml(config.minifyhtml))
            .pipe(gulp.dest('test/dist/'))
            .pipe($.sitemap(config.sitemap))
            .pipe(gulp.dest('test/dist/'));
    });

    gulp.task('dist:fonts', function () {
        gulp.src(['build/fonts/*', '!build/fonts/*.css'])
            .pipe(gulp.dest('fonts/'));
    });

    gulp.task('dist:styles', function () {
        gulp.src('build/*.css')
            .pipe($.header(header))
            .pipe($.rwi(config.rwi))
            .pipe($.uncss(config.uncss))
            .pipe($.combineMediaQueries())
            .pipe($.autoprefixer())
            .pipe($.csso())
            .pipe($.bless())
            .pipe(gulp.dest('./'));
    });

    gulp.task('dist:scripts', function () {
        gulp.src('build/*.js')
            .pipe($.stripDebug())
            .pipe($.uglify())
            .pipe($.header(header))
            .pipe(gulp.dest('./'));
    });

    gulp.task('clean', function (next) {
        del([
            '*.{png,webapp,json,html,css,js,ico,txt,xml}',
            'fonts/',
            '!gulpfile.js',
            '!package.json',
            'build/*',
            '!build/vendor',
            '!build/fonts',
            '!build/logo.png'
        ], next);
    });

    gulp.task('browser-sync', function () {
        sync.init({
            online: online,
            server: { baseDir: 'build/' },
            tunnel: true
        });
    });

    gulp.task('bump', function () {
        gulp.src(['bower.json', 'package.json'])
            .pipe($.bump(config.bump))
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
                    .src(data.tunnel, resolutions, config.pageres)
                    .dest('test/screenshots/');
                pageres.run(function (error) {
                    $.util.log(error || 'Successfully created screenshots');
                    sync.exit();
                });
            });
        }
    });

    gulp.task('pagespeed', ['refresh', 'browser-sync'], function () {
        sync.emitter.on("service:running", function (data) {
            config.pagespeed.url = data.tunnel;
            pagespeed(config.pagespeed, sync.exit);
        });
    });

    gulp.task('size', function () {
        gulp.src(['*', 'fonts/*'])
            .pipe($.size(config.size));
    });

    gulp.task('refresh', function (callback) {
        isOnline(function (error, connection) {
            if (error) {
                throw error;
            }
            if (!connection) {
                $.util.log('NOTE: Internet connection is currently down, W3C.js and Favicons are suppressed.');
            }
            runSequence(['build:copy', 'build:templates', 'build:fonts', 'build:images', 'build:sprites', 'build:scripts'], 'build:styles', callback);
        });
    });

    gulp.task('preview', function (callback) {
        runSequence('refresh', 'browser-sync', callback);
        gulp.watch(['index.jade', 'pages/*.jade', 'styles/**/*.less', 'scripts/*.coffee', 'gulpfile.js'], ['refresh']);
    });

    gulp.task('default', function (callback) {
        runSequence('clean', 'refresh', 'dist:bundle', ['dist:copy', 'dist:templates', 'dist:fonts', 'dist:styles', 'dist:scripts'], callback);
    });

}());

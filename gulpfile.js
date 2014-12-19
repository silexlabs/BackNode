var gulp = require('gulp');
var concat = require('gulp-concat');
var sourcemaps = require('gulp-sourcemaps');

gulp.task('default', ['template', 'js', 'html', 'css', 'bower']);

// build / copy -> html / jade
var jade = require('gulp-jade');
gulp.task('html', function() {
    return gulp.src('./src/index.jade')
        .pipe(sourcemaps.init())
        .pipe(jade())
        .pipe(concat('index.html'))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('./dist/'))
});

// build / copy -> css / sass
var sass = require('gulp-sass');
gulp.task('css', function () {
    return gulp.src('./src/index.scss')
        .pipe(sourcemaps.init())
        .pipe(sass())
        .pipe(concat('backnode.css'))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('./dist/'));
});

// update / copy -> libs
var bower = require('gulp-bower');
gulp.task('bower', function() {
    return bower()
        .pipe(gulp.dest('./dist/lib/'));
});

// copy -> static
gulp.task('template', function(){
  gulp.src(["./static/templates/**/*.*"], { base: './static' })
  .pipe(gulp.dest('dist'));
});

// build / copy -> haxe
var spawn = require('child_process').spawn;
gulp.task('js', function(){
    var child = spawn("haxe", ["build.hxml"]);
    var stdout = '', stderr = '';
    child.stdout.setEncoding('utf8');
    child.stdout.on('data', function (data) {
        stdout += data;
        console.log(data);
    });
    child.stderr.setEncoding('utf8');
    child.stderr.on('data', function (data) {
        stderr += data;
        console.log(data);
    });
    child.on('close', function(code) {
        console.log("Haxe build done with exit code", code);
    });
    return gulp;
});

// watch
gulp.task('watch', function(){
    gulp.watch(['src/**/*.hx', 'build.hxml', 'gulpfile.js'], ['js']);
    gulp.watch(['src/**/*.scss', 'gulpfile.js'], ['css']);
    gulp.watch(['src/**/*.jade', 'gulpfile.js'], ['html']);
});

var gulp = require('gulp');
var concat = require('gulp-concat');
var sourcemaps = require('gulp-sourcemaps');

var jade = require('gulp-jade');
gulp.task('html', function() {
  gulp.src('./src/**/*.jade')
  .pipe(sourcemaps.init())
  .pipe(jade())
  .pipe(concat('backnode.html'))
  .pipe(sourcemaps.write())
  .pipe(gulp.dest('./dist/'))
});


var sass = require('gulp-sass');
gulp.task('css', function () {
  gulp.src('./src/**/*.scss')
  .pipe(sourcemaps.init())
  .pipe(sass())
  .pipe(concat('backnode.css'))
  .pipe(sourcemaps.write())
  .pipe(gulp.dest('./dist/'));
});

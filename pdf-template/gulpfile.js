var gulp = require('gulp'),
    plugins = require('gulp-load-plugins')(),
    connect = require('gulp-connect');

var config = {
  src: 'src',
  dest: '../pdf-template-build/',
  dir: {
    scss: 'scss',
    css: 'css'
  }
};

// Clean
gulp.task('clean', function() {
  return gulp.src(config.dest, {read:false})
    .pipe(plugins.clean({force: true}));
});

// Mustache 
gulp.task('mustache', function() {
  return gulp.src(config.src + '/*.mustache')
    .pipe(plugins.mustache('src/views/view.json'))
    .pipe(gulp.dest(config.src + '/'));
});

// Styles
gulp.task('styles', function() {
  return gulp.src(config.src + '/' + config.dir.scss + '/*.scss')
    .pipe(plugins.rubySass({ style: 'expanded', }))
    .pipe(plugins.autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
    .pipe(gulp.dest(config.src + '/' + config.dir.css));
});

// Inline CSS
gulp.task('inline', function() {
  return gulp.src(config.src + '/*.mustache')
    .pipe(plugins.inlineCss())
    .pipe(gulp.dest(config.dest));;
});

// Connect
gulp.task('connect', connect.server({
    root: [config.src],
    port: 9000,
    livereload: true,
    open: {
      browser: 'Google Chrome'
    }
  })
);

// Serve 
gulp.task('serve', ['connect'], function () {
  gulp.watch([
    config.src + '/*.html',
    config.src + '/css/**/*.css',
  ], function (event) {
    return gulp.src(event.path)
      .pipe(connect.reload());
  });

  gulp.watch(config.src + '/' + config.dir.scss + '/**/*.scss', ['styles']);
  gulp.watch(config.src + '/**/*.mustache', ['mustache']);
});

gulp.task('build', ['clean'], function() {
  gulp.start('styles', 'inline');
});

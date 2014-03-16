# inliner
small boilerplate based on [gulp](http://gulpjs.com/), which inlines linked css directly into your html file, while
giving you easy live preview and the comfort to write scss.  

## where it really shines
Email newsletters and templates. For a complete breakdown of all supported selectors in emails, have a look at Campaign Monitors' [CSS Support Guide](http://www.campaignmonitor.com/css/).

## Installation
Download inliner and add it to your project. run `npm install` to install gulp and all required plugins.

## Usage

### developing and previewing
run `gulp serve` to preview your site locally. If you have livereload installed, your site refreshes automatically on changes.

### building your templates
use `gulp build` to compile your templates and inline the linked css.

## Customization
you can change the asset paths as well as the output directory at the beginning of the `Gulpfile.js`. Depending on how you use it, you might want to tweak the settings of [gulp-inline-css](https://github.com/jonkemp/gulp-inline-css) - like wether to inline styles already in `<style></style>` or not. If you're using Mailchimp, you should have a look at [gulp-mc-inline-css](https://www.npmjs.org/package/gulp-mc-inline-css).

## Get in touch
If you have any questions, thoughts, improvements or modifications you can create an issue, fork this repo or hit me up on [twitter](https://twitter.com/rnarius).
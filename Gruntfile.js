module.exports = function(grunt) {
  const fs = require('fs');
  const mdconfig = JSON.parse(fs.readFileSync('./.markdownlintrc', 'utf8'));

  grunt.initConfig({
    markdownlint: {
      options: {
        config: mdconfig
      },
      src: [ '*.md', 'apps/*/*.md' ]
    }
  });

  grunt.loadNpmTasks('grunt-markdownlint');

  grunt.registerTask('default', ['markdownlint']);

};

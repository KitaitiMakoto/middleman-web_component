Middleman Web Components
========================

Middleman extension which provides a helper and execute vulcanize for Web Components.

Usage
-----

This extension does two things: providing a helper generate link to Web Components HTML files and vulcanize Web Components HTML files on build.

### `component_import_tag` helper ###

    <%= component_import_tag :elements %>

is expanded to

    <link href="components/elements.vulcanized.html" rel="import" />

Directory for Web Components(`components` here) is specified by `directory` option and suffix(`.vulcanized.html` here) is specified by `suffix` option as described later.

### Vulcanize ###

In build process, Middleman Web Components searches HTML files under the Web Components directory and vulcanize(inline external component HTMLs) them.

To vulcanize, the command specified by `command` option is used.

If you're not familiar with vulcanize, see [NPM module page][vulcanize] at first.

Installation
------------

Add

    gem 'middleman-web_components'

to your `Gemfile` and run `bundle install`.

Requirements
------------

* `vulcanize` command, provided by [vulcanize][] NPM module

Configuration
-------------

    activate :web_components

### Options ###

    activate :web_components do |web_components|
      web_components.suffix    = '.vulcanized.html' # Suffix appended to vulcanized files
      web_components.directory = 'components'       # Directory for web components
      web_components.command   = 'vulcanize'        # vulcanize command such as vulcanize, /usr/local/bin/valucanize or $(npm bin)/vulcanize
    end

License
-------

LGPL. See {file:COPYING.txt} for details.

[vulcanize]: https://www.npmjs.com/package/vulcanize

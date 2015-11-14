# Require core library
require 'middleman-core'

# Extension namespace
class Middleman::WebComponent < ::Middleman::Extension
  option :my_option, 'default', 'An example option'

  def initialize(app, options_hash={}, &block)
    # Call super to build options from the options_hash
    super

    # Require libraries only when activated
    # require 'necessary/library'

    # set up your extension
    # puts options.my_option

    app.after_build do |builder|
      command = 'cd source && vulcanize -o ../build/components/elements.vulcanized.html components/elements.html'
      $stderr.puts "run: #{command}"
      $stderr.puts `#{command}`
    end
  end

  def after_configuration
    # Do something
  end

  # A Sitemap Manipulator
  # def manipulate_resource_list(resources)
  # end

  helpers do
    def component_import_tag(*sources)
      options = {
        rel: 'import'
      }.update(sources.extract_options!.symbolize_keys)
      sources.flatten.inject(ActiveSupport::SafeBuffer.new) do |all, source|
        components_dir = app.config[:components_dir] || 'components'
        suffix = app.config[:component_suffix] || '.html'
        url = url_for(File.join(components_dir, "#{source}#{suffix}"), relative: true)
        all << tag(:link, {href: url}.update(options))
      end
    end
  end
end

# Register extensions which can be activated
# Make sure we have the version of Middleman we expect
# Name param may be omited, it will default to underscored
# version of class name

::Middleman::Extensions.register(:web_component, ::Middleman::WebComponent)

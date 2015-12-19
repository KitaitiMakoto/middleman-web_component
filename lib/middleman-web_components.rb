require 'middleman-core'

class Middleman::WebComponents < ::Middleman::Extension
  option :suffix, '.vulcanized.html', 'Suffix appended to vulcanized files'
  option :directory, 'components', 'Directory for web components'
  option :command, 'vulcanize', 'vulcanize command such as vulcanize, /usr/local/bin/valucanize or $(npm bin)/vulcanize'

  def initialize(app, options_hash={}, &block)
    super
  end

  def after_configuration
  end

  def manipulate_resource_list(resources)
    resources.collect do |resource|
      next resource if resource.ignored?
      next resource unless resource.path.start_with? options.directory
      command = `#{options.command} #{resource.source_file}`
      resource = Middleman::Sitemap::StringResource.new(app.sitemap, resource.path, content)
      resource.destination_path = Pathname(resource.path).sub_ext(options.suffix).to_path unless resource.ext == options.suffix
      resource
    end
  end

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

::Middleman::Extensions.register(:web_components, ::Middleman::WebComponents)

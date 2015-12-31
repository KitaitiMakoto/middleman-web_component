require 'middleman-core'

class Middleman::WebComponents < ::Middleman::Extension
  option :suffix, '.vulcanized.html', 'Suffix appended to vulcanized files'
  option :directory, 'components', 'Directory for web components'
  option :command, 'vulcanize', 'vulcanize command such as vulcanize, /usr/local/bin/valucanize or $(npm bin)/vulcanize'

  def manipulate_resource_list(resources)
    resources.collect do |resource|
      next resource if resource.ignored?
      next resource unless resource.path.start_with? options.directory
      content = `#{options.command} #{resource.source_file}`
      resource = Middleman::Sitemap::StringResource.new(app.sitemap, resource.path, content)
      resource.destination_path = Pathname(resource.path).sub_ext(options.suffix).to_path unless resource.ext == options.suffix
      resource
    end
  end

  helpers do
    def component_import_tag(*sources)
      extension = app.extensions[:web_components]
      options = {
        rel: 'import'
      }.update(sources.extract_options!.symbolize_keys)
      sources.flatten.inject(ActiveSupport::SafeBuffer.new) do |all, source|
        url = url_for(File.join(extension.options.directory, "#{source}.html"), relative: true)
        all << tag(:link, {href: url}.update(options))
      end
    end
  end
end

::Middleman::Extensions.register(:web_components, ::Middleman::WebComponents)

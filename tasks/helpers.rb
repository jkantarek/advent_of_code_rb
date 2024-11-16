require "erb"
require "fileutils"

module ScaffoldHelpers
  def self.render_template(template_path, context)
    template = File.read(template_path)
    ERB.new(template).result_with_hash(context)
  end

  def self.create_file(path, content)
    FileUtils.mkpath(File.dirname(path))
    File.write(path, content)
  end
end

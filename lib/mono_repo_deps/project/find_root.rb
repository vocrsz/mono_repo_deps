require 'zeitwerk'
require 'singleton'

class MonoRepoDeps::Project::FindRoot
  include MonoRepoDeps::Mixins

  SYSTEM_ROOT = '/'

  Contract String => String
  def call(dir)
    init_dir = dir = File.expand_path(dir)

    unless Dir.exists?(init_dir)
      raise StandardError.new("path '#{init_dir}' does not exist")
    end

    loop do
      project_file_path = File.expand_path(File.join(dir, MonoRepoDeps::PROJECT_FILENAME))

      if File.exists?(project_file_path)
        return dir
      elsif dir == SYSTEM_ROOT
        raise StandardError.new("#{MonoRepoDeps::PROJECT_FILENAME} for path '#{init_dir}' not found")
      else
        dir = File.expand_path("../", dir)
      end
    end
  end
end
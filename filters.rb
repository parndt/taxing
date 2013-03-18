require 'yaml'
FILTERS = if File.exist?(filter_path = File.expand_path('../filters.yml', __FILE__))
  YAML::load(File.read(filter_path))['filters']
else
  []
end

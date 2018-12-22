require 'json'

config_path = File.expand_path('../../configuration_variables.json', __FILE__)
ENV.update(JSON.load(File.new(config_path))) if File.exist? config_path

%w(environment_variables.rb .muster-env.rb).each do |env_file|
  env_file_path = File.expand_path("../../#{env_file}", __FILE__)
  require env_file_path if File.exist? env_file_path
end
require 'open-uri'
require 'nokogiri'
require 'fileutils'
require 'yaml'
require 'psych'

require "atcoder_greedy/version"
require 'atcoder_greedy/command'

module AtcoderGreedy
  # Configuration defaults
  @config = {
      user_id: '',
      password: '',
      language: 'rb'
  }

  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each { |k, v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym }
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      puts "YAML configuration file couldn't be found. Using defaults."; return
    rescue Psych::SyntaxError
      puts "YAML configuration file contains invalid syntax. Using defaults."; return
    end

    configure(config)
  end

  def self.get_config_path
    config_path = Dir.home + '/.atcoder_greedy'
    if Dir.exists?(config_path)
      # use user settings
      config_path
    else
      # use default settings
      File.join(File.dirname(__dir__), '/lib/atcoder_greedy')
    end
  end

  def self.config
    yml_path = get_config_path + '/settings.yml'
    configure_with(yml_path)
    @config
  end

  def self.save_config
    yml_path = get_config_path + '/settings.yml'
    f = File.open(yml_path, 'w')
    f.print(@config.to_yaml)
    f.close
  end
end

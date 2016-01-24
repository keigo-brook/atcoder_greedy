require 'open-uri'
require 'nokogiri'
require 'fileutils'
require 'yaml'
require 'mechanize'
require 'launchy'

require "atcoder_greedy/version"
require 'atcoder_greedy/command'

module AtcoderGreedy
  # Configuration defaults
  @config = {
      user_id: '',
      password: '',
      language: '',
      default_template: {
          rb: '',
          cpp: '',
          c: '',
          py: ''
      }
  }

  @valid_languages = %w(rb cpp c py)
  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    self.config
    opts.each do |k, v|
      if v.is_a?(Hash)
        v.each do |ck, cv|
          @config[k.to_sym][ck.to_sym] = cv if @valid_languages.include?(ck.to_s)
        end
      else
        @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym
      end
    end
    self.save_config
  end

  def self.get_config_path
    config_path = Dir.home + '/.atcoder_greedy'
    if Dir.exists?(config_path)
      config_path
    else
      raise "Can't find config directory. please init by command: 'atcoder_greedy config'.'"
    end
  end

  def self.config
    yml_path = get_config_path + '/settings.yml'
    yml_file = YAML.load_file(yml_path)
    if yml_file
      @config = yml_file
    else
      File.open(yml_path, 'w') { |f| YAML.dump(@config, f) }
    end
  end

  def self.save_config
    yml_path = get_config_path + '/settings.yml'
    if File.exists?(yml_path)
      File.open(yml_path, 'w') { |f| YAML.dump(@config, f) }
    else
      raise "Can't find #{yml_path}. please set configure."
    end
  end
end

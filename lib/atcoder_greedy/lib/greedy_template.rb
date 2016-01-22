# require 'FileUtils'
require 'atcoder_greedy'

class GreedyTemplate
  def initialize
    @dir = AtcoderGreedy::get_config_path + '/templates'
    Dir.mkdir(@dir) unless Dir.exists?(@dir)
  end

  def add(file_path)
    # save template to language directory
    file = File.open(file_path)
    file_name = File.basename(file_path)
    type_dir = @dir + '/' + File.extname(file_path).delete('.')
    Dir.mkdir(type_dir) unless Dir.exists?(type_dir)
    if File.exists?(type_dir + '/' + file_name)
      print "Template [#{file_name}] is already exists. Do you update?[y/N]:"
      s = $stdin.gets.chomp
      if s == 'y' || s == 'yes'
        FileUtils.cp(file, type_dir)
        puts 'Template file is updated.'
        puts "if you want to use this file as a default, please run 'atcoder_greedy template -s #{file_name}'"
      end
    else
      FileUtils.cp(file, type_dir)
      puts 'Template file is added.'
      puts "if you want to use this file as a default, please run 'atcoder_greedy template -s #{file_name}'"
    end
  end

  def list
    puts "Show Template file lists. [d] is this language default. ---------------------"
    Dir::glob(@dir + '/*').each do |l|
      puts "#{File.basename(l)}:"
      Dir::glob("#{l}/*").each do |f|
        default = get_default(File.basename(l))
        if default != nil && File.basename(f) == default
          print '  [d] '
        else
          print '    - '
        end
        puts "#{File.basename(f)}"
      end
    end
  end

  def set_default(file_name)
    type = File.extname(file_name).delete('.')
    type_dir = @dir + '/' + type
    file = type_dir + '/' + File.basename(file_name)
    if File.exists?(file)
      AtcoderGreedy.configure(default_template: {"#{type}": file})
      puts 'Set new default template.'
    else
      puts "File [#{file_name}] doesn't exists. confirm input name."
      self.list
    end
  end

  def delete(file_name)
    type = File.extname(file_name).delete('.')
    type_dir = @dir + '/' + type
    file = type_dir + '/' + File.basename(file_name)
    if File.exists?(file)
      print "Do you delete [#{file_name}]?[y/N]:"
      s = $stdin.gets.chomp
      if s == 'y' || s == 'yes'
        if File.basename(file_name) == get_default(type)
          AtcoderGreedy.configure(default_template: {"#{type}": ''})
        end
        FileUtils.remove_file(file)
        puts 'Template file is deleted.'
      end
    else
      puts "File [#{file_name}] doesn't exists. confirm input name."
      self.list
    end
  end

  def self.get_template_path(file_name)
    type = File.extname(file_name).delete('.')
    type_dir = AtcoderGreedy::get_config_path + '/templates' + '/' + type
    file = type_dir + '/' + File.basename(file_name)
    File.exists?(file) ? file : nil
  end

  private
  def get_default(language)
    unless AtcoderGreedy.config[:default_template][:"#{language}"].nil?
      File.basename(AtcoderGreedy.config[:default_template][:"#{language}"])
    end
  end
end
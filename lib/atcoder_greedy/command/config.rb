require 'atcoder_greedy'
require 'atcoder_greedy/command'

module AtcoderGreedy
  class Command < Thor
    desc 'config', 'change settings'

    def config
      config_path = Dir.home + '/.atcoder_greedy'
      unless Dir.exists?(config_path)
        Dir.mkdir(config_path)
        File.new(config_path + '/settings.yml', 'w')
      end
      languages = %w(rb cpp)
      puts "Your current language is [#{AtcoderGreedy.config[:language]}]."
      puts "Choose New language from: #{languages}"
      print "Input languages: "
      loop do
        s = $stdin.gets.chomp!
        if languages.include?(s)
          AtcoderGreedy.configure(language: s)
          break
        elsif s.size != 0
          puts "Invalid language. please try again:"
        else
          break
        end
      end

      AtcoderGreedy.save_config
      puts "Update Your default language to [#{AtcoderGreedy.config[:language]}]."
    end
  end
end

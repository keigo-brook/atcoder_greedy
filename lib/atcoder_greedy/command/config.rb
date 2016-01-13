require 'atcoder_greedy'
require 'atcoder_greedy/command'
require 'atcoder_greedy/lib/languages'
module AtcoderGreedy
  class Command < Thor
    desc 'config', 'change settings'

    def config
      languages = Languages::ALL_LANGUAGES
      config_path = Dir.home + '/.atcoder_greedy'
      if Dir.exists?(config_path)
        puts "Your current language is [#{AtcoderGreedy.config[:language]}]."
      else
        Dir.mkdir(config_path)
        File.new(config_path + '/settings.yml', 'w')
      end
      puts "Choose default language from: #{languages}"
      print "Input languages: "
      loop do
        s = $stdin.gets.chomp!
        if languages.include?(s)
          AtcoderGreedy.configure(language: s)
          break
        elsif s.size == 0
          break
        elsif puts "Invalid language. please try again:"
        end
      end

      AtcoderGreedy.save_config
      puts "Update Your default language to [#{AtcoderGreedy.config[:language]}]."
    end
  end
end

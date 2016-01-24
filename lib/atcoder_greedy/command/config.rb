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
        puts "Your current user_id is #{AtcoderGreedy.config[:user_id]} and current language is [#{AtcoderGreedy.config[:language]}]."
      else
        Dir.mkdir(config_path)
        yml_path = AtcoderGreedy.get_config_path + '/settings.yml'
        File.open(yml_path, 'w').close
      end

      # user setting
      agent = Mechanize.new
      loop do
        print 'Input your user_id: '
        user_id = $stdin.gets.chomp!
        print 'Input your password: '
        password = $stdin.gets.chomp!
        break if user_id.size == 0 || password.size == 0

        print 'Doing test login ...'
        response = nil
        agent.get('http://abc032.contest.atcoder.jp/login') do |page|
          response = page.form_with(action: '/login') do |f|
            f.field_with(name: 'name').value = user_id
            f.field_with(name: 'password').value = password
          end.submit
        end

        if response.response['x-imojudge-simpleauth'] == 'Passed'
          puts 'OK!'
          AtcoderGreedy.configure(user_id: user_id)
          AtcoderGreedy.configure(password: password)
          break
        else
          puts 'Failed! Cofirm input and try again.'
        end
      end

      # language setting
      puts "Choose default language from: #{languages}"
      print "Input languages: "
      loop do
        s = $stdin.gets.chomp!
        if languages.include?(s)
          AtcoderGreedy.configure(language: s)
          puts "Update Your default language to [#{AtcoderGreedy.config[:language]}]."
          break
        elsif s.size == 0
          break
        else
          puts "Invalid language. please try again:"
        end
      end
    end
  end
end

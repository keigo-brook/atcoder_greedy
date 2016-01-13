require 'atcoder_greedy'
require 'atcoder_greedy/command'

module AtcoderGreedy
  class Command < Thor
    desc 'destroy [CONTESTNAME]', 'destroy contest templates for [CONTESTNAME]'

    def destroy(contest_name)
      puts "Destroy ./#{contest_name} [y/n]?"
      s = $stdin.gets
      if s == 'y' || s == 'yes'
        if system("rm -r ./#{contest_name}")
          puts 'deleted.'
        else
          raise 'Runtime Error'
        end
      end
    end
  end
end

require 'atcoder_greedy'
require 'atcoder_greedy/command'
require 'atcoder_greedy/lib/contest'

module AtcoderGreedy
  class Command < Thor
    desc 'create [CONTESTURL]', 'create contest templates for [CONTESTURL]'
    option :only_templates, aliases: "\--ot"
    option :only_input, aliases: "\--oi"
    option :select_problem, aliases: '-p', default: 'A B C D', desc: 'create only select problem'
    option :set_directory, aliases: '-d', default: '', desc: 'set target directory'
    def create(contest_url)
      user_options = {
          only: '',
          problem: options[:select_problem].split,
          directory: options[:set_directory]
      }
      if options[:only_input] && options[:only_templates]
        raise "Command Argument Error: You can't use 'only' options at the same time."
      elsif options[:only_input]
        user_options[:only] = 'input'
      elsif options[:only_templates]
        user_options[:only] = 'templates'
      end

      Contest.new(contest_url, user_options)
    end
  end
end

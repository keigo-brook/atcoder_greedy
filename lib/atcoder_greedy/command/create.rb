require 'atcoder_greedy'
require 'atcoder_greedy/command'
require 'atcoder_greedy/lib/contest'

module AtcoderGreedy
  class Command < Thor
    desc 'create [CONTESTURL]', 'create contest templates for [CONTESTURL]'
    option :only_templates, aliases: "\--ot"
    option :only_input, aliases: "\--oi"
    option :select_problem, aliases: '-p', default: nil, desc: 'create only select problem'
    option :set_directory, aliases: '-d', default: '', desc: 'set target directory'
    def create(contest_url)
      user_options = {
          only: '',
          problems: [],
          directory: options[:set_directory]
      }
      if options[:only_input] && options[:only_templates]
        raise "Command Argument Error: You can't use 'only' options at the same time."
      elsif options[:only_input]
        user_options[:only] = 'input'
      elsif options[:only_templates]
        user_options[:only] = 'templates'
      end

      user_options[:problems] = options[:select_problem].split unless options[:select_problem].nil?

      Contest.new(contest_url, user_options)
    end
  end
end

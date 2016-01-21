require 'atcoder_greedy'
require 'atcoder_greedy/command'
require 'atcoder_greedy/lib/contest'

module AtcoderGreedy
  class Command < Thor
    desc 'create [CONTESTNAME]', 'create contest templates for [CONTESTNAME]'
    option :only_templates, aliases: "\-ot"
    option :only_input, aliases: "\--oi"
    def create(contest_name)
      if options[:only_input] && options[:only_templates]
        raise "Command Argument Error: You can't use 'only' options at the same time."
      elsif options[:only_input]
        Contest.new(contest_name.downcase, only: 'input')
      elsif options[:only_templates]
        Contest.new(contest_name, only: 'templates')
      else
        Contest.new(contest_name, only: '')
      end
    end
  end
end

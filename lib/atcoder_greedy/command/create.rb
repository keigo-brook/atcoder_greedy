require 'atcoder_greedy'
require 'atcoder_greedy/command'
require 'atcoder_greedy/lib/contest'

module AtcoderGreedy
  class Command < Thor
    desc 'create [CONTESTURL]', 'create contest templates for [CONTESTURL]'
    option :no_templates, type: :boolean, default: false, aliases: "\--nt"
    option :no_input, type: :boolean, default: false, aliases: "\--ni"
    option :select_problem, aliases: '-p', default: nil, desc: 'create only select problem'
    option :select_directory, aliases: '-d', default: '', desc: 'select target directory'
    option :select_language, aliases: '-l', default: '', desc: 'select language'
    option :select_template, aliases: '-t', default: '', desc: 'select generate template'

    def create(contest_url)
      user_options = {
          without: {input: false, template: false},
          problems: [],
          directory: options[:select_directory],
          language: options[:select_language],
          template: options[:select_template]
      }

      user_options[:without][:input] = true if options[:no_input]
      user_options[:without][:template] = true if options[:no_templates]
      user_options[:problems] = options[:select_problem].split unless options[:select_problem].nil?

      Contest.new(contest_url, user_options)
    end
  end
end

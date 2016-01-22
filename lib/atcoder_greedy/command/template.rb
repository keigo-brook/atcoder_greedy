require 'atcoder_greedy'
require 'atcoder_greedy/command'
require 'atcoder_greedy/lib/greedy_template'

module AtcoderGreedy
  class Command < Thor
    desc 'template [OPTION]', 'set template'
    option :add, aliases: '-a'
    option :list, aliases: '-l'
    option :set_default, aliases: '-s'
    option :delete, aliases: '-d'
    def template
      temp = GreedyTemplate.new
      if options[:add]
        temp.add(options[:add])
      elsif options[:list]
        temp.list
      elsif options[:set_default]
        temp.set_default(options[:set_default])
      elsif options[:delete]
        temp.delete(options[:delete])
      end
    end
  end
end


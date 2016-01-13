require 'atcoder_greedy'
require 'atcoder_greedy/command'
require 'atcoder_greedy/lib/contest'

module AtcoderGreedy
  class Command < Thor
    desc 'create [CONTESTNAME]', 'create contest templates for [CONTESTNAME]'

    def create(contest_name)
      Contest.new(contest_name.downcase)
    end
  end
end

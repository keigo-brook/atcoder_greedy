require 'atcoder_greedy'
require 'atcoder_greedy/command'
require 'atcoder_greedy/lib/test_case'

module AtcoderGreedy
  class Command < Thor
    desc 'test [PROBLEM_FILE_NAME]', 'test your solution'

    def test(problem_name)
      TestCase.new(problem_name).validate
    end
  end
end


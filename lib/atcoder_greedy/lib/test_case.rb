require 'diff/lcs'
require 'tempfile'
require 'benchmark'
require 'atcoder_greedy/lib/languages'

class TestCase
  def initialize(problem_name)
    language = File.extname(problem_name)
    if language.size == 0
      language = '.' + AtcoderGreedy.config[:language]
      problem_name = problem_name + language
    end
    puts "Running a test for problem #{problem_name}..."

    @problem_name = File.basename(problem_name, '.*')
    @input_file = File.open("./input_#{@problem_name}.txt", 'r')
    @exec_file = "./#{@problem_name}#{language}"
    get_in_out
  end

  def get_in_out
    i = 0
    @input = []
    @output = []
    now = nil
    while (t = @input_file.gets) != nil
      example_string = "-- Example #{i}"
      answer_string = "-- Answer #{i}"

      if t.chomp == example_string
        now.close(false) unless now.nil?
        now = Tempfile.new(['in', '.txt'], './')
        @input.push(now)
        now.open
      elsif t.chomp == answer_string
        now.close(false) unless now.nil?
        now = Tempfile.new(['out', '.txt'], './')
        @output.push(now)
        now.open
        i += 1
      else
        now.puts t
      end
    end
    @input[-1].close(false)
    @output[-1].close(false)
  end

  def validate
    my_solve = get_solve(@exec_file)
    passed = 0
    begin
      if my_solve.compile(@problem_name)
        puts '-------------------- Compile Done --------------------'
      else
        raise 'Compile Error'
      end

      @input.size.times do |j|
        myout_file = Tempfile.new(['myout', '.txt'], './')
        myout_file.open
        result = Benchmark.realtime do
          unless my_solve.execute(@input[j].path, myout_file.path)
            raise "Runtime Error"
          end
          @input[j].close
          myout_file.close(false)
        end

        myout = myout_file.open.read
        myout_file.close
        correct = File.open("#{@output[j].path}").read
        diffs = Diff::LCS.diff(myout, correct)
        if diffs.size == 0
          passed += 1
          puts "-------------------- Testcase ##{j} -------------------- PASSED! Time: #{sprintf("%.5f", result)}s"
        else
          puts "-------------------- Testcase ##{j} -------------------- FAILED! Time: #{sprintf("%.5f", result)}s"
          puts 'Your Output:'
          puts "#{myout}\n"
          puts 'Correct Answer:'
          puts "#{correct}\n"
        end
      end
      puts "Test done. #{passed}/#{@input.size} passed."
    rescue => e
      puts e
    end
  end

  # HACK: move to Languages
  def get_solve(solve_file)
    case File.extname(solve_file)
      when '.rb'
        Rb.new(solve_file)
      when '.cpp'
        Cpp.new(solve_file)
      when '.c'
        C.new(solve_file)
      else
        raise 'Unknown Language'
    end
  end
end

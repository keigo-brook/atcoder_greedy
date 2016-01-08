# coding: utf-8
require 'test/unit'
require_relative 'PROBLEM.rb'

class Test_NAME < Test::Unit::TestCase
  def setup
    @test_cases = create_test_cases
    @sample_outputs = get_outputs
  end

  def create_test_cases
    test_cases = []
    in_file = File.open('./input.txt', 'r+:utf-8')
    loop do
      s = ''
      loop do
        t = in_file.gets
        if t != nil && t.chomp.length > 0
          s += t
        else
          break
        end
      end
      if s.length == 0 && test_cases.size > 0
        break
      elsif s.length > 0
        test_case = NAME.new(s)
        test_cases.push(test_case)
      end
    end
    test_cases
  end

  def get_outputs
    outputs = []
    out_file = File.open('./output.txt', 'r+:utf-8')
    loop do
      s = ''
      loop do
        t = out_file.gets
        if t != nil && t.chomp.length > 0
          s += t
        else
          break
        end
      end
      if s.length == 0 && outputs.size > 0
        break
      elsif s.length > 0
        outputs.push(s.chomp)
      end
    end
    outputs
  end

  def test_PROBLEM
    @test_cases.each_with_index do |obj, i|
      assert_equal(@sample_outputs[i], obj.solve.to_s)
    end
  end
end
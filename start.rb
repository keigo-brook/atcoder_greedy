require 'open-uri'
require 'nokogiri'
require 'active_support'
require 'fileutils'

TEST_TEMPLATE =
"
require 'test/unit'
require './FILE.rb'

class Test_NAME < Test::Unit::TestCase
  def setup
    @test_cases = create_test_cases
    @sample_outputs = get_outputs
  end

  def create_test_cases
    test_cases = []
    in_file = File.open('in.txt', 'r+:utf-8')
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
    out_file = File.open('out.txt', 'r+:utf-8')
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

  def test_foo
    @test_cases.each_with_index do |obj, i|
      assert_equal(@sample_outputs[i], obj.solve)
    end
  end
end
"

SOLVE_TEMPLATE =
"
require 'stringio'

class NAME
  alias :puts_original :puts
  def initialize(input)
    @f = StringIO.new(input)
  end

  def gets
    @f.gets
  end

  def puts(a)
    puts_original a
    a
  end

  def solve
    # write your program here
  end
end
"

base_url = ARGV[0]

if base_url.nil? || base_url.length == 0
  puts 'url error'
  exit
end

# http://abc008.contest.atcoder.jp
contest_name = base_url[7..12]
urls = []
if (contest_name.include?('abc') && contest_name[3..5].to_i > 19) ||
    (contest_name.include?('arc') && contest_name[3..5].to_i > 34)
  task_num = %w(a b c d)
else
  task_num = %w(1 2 3 4)
end

4.times do |i|
  urls.push(name: "#{contest_name}_#{task_num[i]}", path: base_url + "/tasks/#{contest_name}_#{task_num[i]}")
end

FileUtils.mkdir(contest_name)

urls.each do |url|
  charset = nil
  html = open(url[:path]) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)

  FileUtils.mkdir("./#{contest_name}/#{url[:name]}")

  in_file = File.new("./#{contest_name}/#{url[:name]}/in.txt", 'w')
  out_file = File.new("./#{contest_name}/#{url[:name]}/out.txt", 'w')

  test_file_content = TEST_TEMPLATE.clone
  test_file_content.gsub!(/NAME/, url[:name].capitalize)
  test_file_content.gsub!(/FILE/, url[:name])
  test_file = File.new("./#{contest_name}/#{url[:name]}/test_#{url[:name]}.rb", 'w')
  test_file.print test_file_content
  test_file.close

  solve_file_content = SOLVE_TEMPLATE.clone
  solve_file_content.gsub!(/NAME/, url[:name].capitalize)
  solve_file = File.new("./#{contest_name}/#{url[:name]}/#{url[:name]}.rb", 'w')
  solve_file.print solve_file_content
  solve_file.close

  params = doc.xpath('//pre')
  params.shift
  params.each_with_index do |p, i|
    if i % 2 == 0
      in_file.print "#{p.text}"
    else
      out_file.print "#{p.text}"
    end
  end

  in_file.close
  out_file.close

end

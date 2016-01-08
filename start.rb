require 'open-uri'
require 'nokogiri'
require 'active_support'
require 'fileutils'

TEST_TEMPLATE = open("./templates/ruby/test.rb", &:read)
SOLVE_TEMPLATE = open("./templates/ruby/solve.rb", &:read)

class Contest
  attr_accessor :name, :url
  def initialize(name)
    @name = name
    puts "Create #{name} contest files"
    @base_url = create_contest_url(name)
    puts "Contest url is #{@base_url}"
    @problem_urls = create_contest_problem_urls(name)
    puts 'Create directories'
    create_directories
    puts 'Set up done.'
  end

  def create_contest_url(contest_name)
    'http://' + contest_name + '.contest.atcoder.jp'
  end

  def create_contest_problem_urls(contest_name)
    urls = []
    if (contest_name.include?('abc') && contest_name[3..5].to_i > 19) ||
        (contest_name.include?('arc') && contest_name[3..5].to_i > 34)
      task_num = %w(a b c d)
    else
      task_num = %w(1 2 3 4)
    end

    4.times do |i|
      urls.push(name: "#{contest_name}_#{task_num[i]}", path: @base_url + "/tasks/#{contest_name}_#{task_num[i]}")
    end
    urls
  end

  def create_directories
    # コンテストディレクトリ作成
    FileUtils.mkdir(@name)

    @problem_urls.each do |url|
      # urlからインプット、アウトプットパラメータをとってきてファイルにしまう
      charset = nil
      html = open(url[:path]) do |f|
        charset = f.charset
        f.read
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)

      problem_dir = "./#{@name}/#{url[:name]}"
      FileUtils.mkdir(problem_dir)

      in_file = File.new(problem_dir + '/input.txt', 'w')
      out_file = File.new(problem_dir + '/output.txt', 'w')

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

      # テストファイル,解答ファイルの生成
      test_file_content = TEST_TEMPLATE.clone
      test_file_content.gsub!(/NAME/, url[:name].capitalize)
      test_file_content.gsub!(/PROBLEM/, url[:name])
      test_file = File.new(problem_dir + "/test_#{url[:name]}.rb", 'w')
      test_file.print test_file_content
      test_file.close

      solve_file_content = SOLVE_TEMPLATE.clone
      solve_file_content.gsub!(/NAME/, url[:name].capitalize)
      solve_file = File.new(problem_dir + "/#{url[:name]}.rb", 'w')
      solve_file.print solve_file_content
      solve_file.close
    end
  end
end

Contest.new(ARGV[0])
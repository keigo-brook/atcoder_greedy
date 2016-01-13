require 'atcoder_greedy'
require 'atcoder_greedy/command'

module AtcoderGreedy
  class Command < Thor
    desc 'create CONTESTNAME', 'create contest templates for CONTESTNAME'

    def create(contest_name)
      Contest.new(contest_name.downcase)
    end
  end

  TEMPLATE_PATH = '/Users/KeigoOgawa/work/atcoder_greedy/lib/atcoder_greedy/templates/'
  SOLVE_TEMPLATE = open(TEMPLATE_PATH + '/ruby/solve.rb', &:read)
  PROBLEM_NAMES = %w(A B C D)

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
      create_templates
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
        urls.push(name: "#{PROBLEM_NAMES[i]}", path: @base_url + "/tasks/#{contest_name}_#{task_num[i]}")
      end
      urls
    end

    def create_templates
      @problem_urls.each_with_index do |url, pro_i|
        problem_dir = "./#{@name}"
        # urlからインプット、アウトプットパラメータをとってきてファイルにしまう
        charset = nil
        html = open(url[:path]) do |f|
          charset = f.charset
          f.read
        end
        doc = Nokogiri::HTML.parse(html, nil, charset)
        in_file = File.new(problem_dir + "/input_#{PROBLEM_NAMES[pro_i]}.txt", 'w')

        params = doc.xpath('//pre')
        params.shift
        params.each_with_index do |p, i|
          if i % 2 == 0
            in_file.puts "-- Example #{i/2}"
            in_file.puts "#{p.text.gsub(/\r\n?/, "\n").strip}"
          else
            in_file.puts "-- Answer #{(i-1)/2}"
            in_file.puts "#{p.text.gsub(/\r\n?/, "\n").strip}"
          end
        end

        in_file.close

        solve_file_content = SOLVE_TEMPLATE.clone
        solve_file_content.gsub!(/CONTEST/, @name.upcase)
        solve_file_content.gsub!(/PROBLEM/, url[:name].upcase)
        solve_file = File.new(problem_dir + "/#{url[:name]}.rb", 'w')
        solve_file.print solve_file_content
        solve_file.close
      end
    end

    def create_directories
      # コンテストディレクトリ作成
      FileUtils.mkdir(@name)
    end
  end
end
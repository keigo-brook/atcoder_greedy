require 'byebug'

class Contest
  attr_accessor :name, :url

  def initialize(name, **options)
    @language = AtcoderGreedy.config[:language]
    @name = name
    @problem_names = %w(A B C D)

    puts "Create #{name} contest files"
    @base_url = create_contest_url(name)
    puts "Contest url is #{@base_url}"

    @problem_urls = create_contest_problem_urls(name)

    set_directories(options[:directory])

    if options[:only] != 'templates'
      create_inputs
    end

    if options[:only] != 'input'
      template_path = File.join(File.dirname(__dir__), '/templates')
      @solve_template = open(template_path + "/#{@language}/solve.#{@language}", &:read)
      create_templates
    end

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
      urls.push(name: "#{@problem_names[i]}", path: @base_url + "/tasks/#{contest_name}_#{task_num[i]}")
    end
    urls
  end

  def create_inputs
    print 'Create inputs ... '
    @problem_urls.each_with_index do |url, pro_i|
      # urlからインプット、アウトプットパラメータをとってきてファイルにしまう
      charset = nil
      html = open(url[:path]) do |f|
        charset = f.charset
        f.read
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)
      in_file = File.new(@dir + "/input_#{@problem_names[pro_i]}.txt", 'w')

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
    end
    puts 'Done!'
  end

  def create_templates
    print 'Create Templates ... '
    @problem_urls.each_with_index do |url, pro_i|
      solve_file_content = @solve_template.clone
      solve_file_content.gsub!(/DATE/, Time.now.strftime('%F'))
      solve_file_content.gsub!(/CONTEST/, @name.upcase)
      solve_file_content.gsub!(/PROBLEM/, url[:name].upcase)
      solve_file = File.new(@dir + "/#{url[:name]}.#{@language}", 'w')
      solve_file.print solve_file_content
      solve_file.close
    end
    puts 'Done!'
  end

  def set_directories(directory)
    print 'Set contest directory ... '
    if directory == ''
      FileUtils.mkdir(@name)
      @dir = "./#{@name}"
    else
      if Dir.exists?(directory)
        @dir = directory
      else
        raise "ERROR: Directory doesn't exists:#{@dir}"
      end
    end
    puts 'Done!'
  end
end
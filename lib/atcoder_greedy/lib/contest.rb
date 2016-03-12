require 'uri'
require 'cgi'
require 'atcoder_greedy/lib/atcoder'
require 'atcoder_greedy'
require 'atcoder_greedy/lib/greedy_template'

class Contest
  attr_accessor :name, :url, :dir, :problems

  def initialize(url, **options)
    if options[:language] != ''
      @language = options[:language]
    else
      @language = AtcoderGreedy.config[:language]
    end
    @url = url

    set_agent
    set_contest_info(options[:problems])
    set_directories(options[:directory])

    create_inputs unless options[:no][:input]
    create_templates(options[:template]) unless options[:no][:template]

    puts 'Set up done. Go for it!'
  end

  def set_agent
    atcoder = Atcoder.new
    atcoder.login(@url)
    @agent = atcoder.agent
  end

  def set_contest_info(option_problems)
    print 'Set contest info ... '
    @name = URI.parse(@url).host.split('.').first
    html = @agent.get(@url + '/assignments').content.toutf8
    doc = Nokogiri::HTML.parse(html, nil, 'utf8')

    all_problems = []
    task_ids = []
    doc.xpath('//tbody').each do |tbody|
      tbody.xpath('.//a[starts-with(@href,"/submit")]').each do |a|
        task_ids.push(CGI.parse(URI.parse(a.attributes['href'].value).query)['task_id'].first)
      end
      all_problems = tbody.xpath('.//a[@class="linkwrapper"]')
    end

    @problems = []
    if all_problems.nil?
      raise 'Failed to get info. Do you participate this contest?'
    else
      until all_problems.empty?
        path = all_problems[0].attributes['href'].value
        pro = all_problems.select { |l| l.attributes['href'].value == path }
        all_problems = all_problems.reject { |l| l.attributes['href'].value == path }
        name = pro[0].inner_text
        if option_problems.empty? || (!option_problems.empty? && option_problems.include?(name))
          @problems.push(name: pro[0].inner_text, path: path, task_id: task_ids.shift)
          print "#{name} "
        end
      end
    end
    puts 'Done!'
  end

  def create_inputs
    print 'Create inputs ... '
    @problems.each do |problem|
      # take input and output params from url and save to file
      html = @agent.get(@url + problem[:path]).content.toutf8
      doc = Nokogiri::HTML.parse(html, nil, 'utf8')
      in_file = File.new(@dir + "/input_#{problem[:name]}.txt", 'w')

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

  def create_templates(option_template)
    print 'Create Templates ... '
    if option_template.to_s == ''
      # use system default or user default template
      if AtcoderGreedy.config[:default_template][:"#{@language}"].nil? || AtcoderGreedy.config[:default_template][:"#{@language}"].to_s == ''
        solve_template = open(File.dirname(__dir__) + '/templates' + "/#{@language}/solve.#{@language}", &:read)
      else
        solve_template = open(AtcoderGreedy.config[:default_template][:"#{@language}"], &:read)
      end
    else
      # use option_template
      template_path = GreedyTemplate.get_template_path(option_template)
      if template_path.nil?
        raise "ERROR: Template #{option_template} doesn't found"
      else
        solve_template = open(template_path, &:read)
      end
    end

    @problems.each_with_index do |problem|
      solve_file_content = solve_template.clone
      solve_file_content.gsub!(/DATE/, Time.now.strftime('%F'))
      solve_file_content.gsub!(/CONTEST/, @name.upcase)
      solve_file_content.gsub!(/PROBLEM/, problem[:name])
      solve_file = File.new(@dir + "/#{problem[:name]}.#{@language}", 'w')
      solve_file.print solve_file_content
      solve_file.close
    end
    puts 'Done!'
  end

  def set_directories(directory)
    print 'Set contest directory ... '
    if directory.to_s == ''
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
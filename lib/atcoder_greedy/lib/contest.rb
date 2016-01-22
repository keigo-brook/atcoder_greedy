require 'uri'
require 'atcoder_greedy'
require 'atcoder_greedy/lib/greedy_template'

class Contest
  attr_accessor :name, :url

  def initialize(url, **options)
    if options[:language] != ''
      @language = options[:language]
    else
      @language = AtcoderGreedy.config[:language]
    end
    @url = url
    set_contest_info(options[:problems])
    set_directories(options[:directory])

    create_inputs unless options[:without][:input]
    create_templates(options[:template]) unless options[:without][:template]

    puts 'Set up done. Go for it!'
  end

  def set_contest_info(option_problems)
    print 'Set contest info ... '
    @name = URI.parse(@url).host.split('.').first
    charset = nil
    html = open(@url + '/assignments') do |f|
      charset = f.charset
      f.read
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)

    all_problems = nil
    doc.xpath('//tbody').each do |tbody|
      all_problems = tbody.xpath('.//a[@class="linkwrapper"]')
    end

    @problems = []
    until all_problems.empty?
      path = all_problems[0].attributes['href'].value
      pro = all_problems.select { |l| l.attributes['href'].value == path }
      all_problems = all_problems.reject { |l| l.attributes['href'].value == path }
      name = pro[0].inner_text
      if option_problems.empty? || (!option_problems.empty? && option_problems.include?(name))
        @problems.push(name: pro[0].inner_text, path: path)
        print "#{name} "
      end
    end
    puts 'Done!'
  end

  def create_inputs
    print 'Create inputs ... '
    @problems.each do |problem|
      # take input and output params from url and save to file
      charset = nil
      html = open(@url + problem[:path]) do |f|
        charset = f.charset
        f.read
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)
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
    if option_template == ''
      # use user default or system default template
      if AtcoderGreedy.config[:default_template][:"#{@language}"] != ''
        solve_template = open(AtcoderGreedy.config[:default_template][:"#{@language}"], &:read)
      else
        solve_template = open(File.dirname(__dir__) + '/templates' + "/#{@language}/solve.#{@language}", &:read)
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
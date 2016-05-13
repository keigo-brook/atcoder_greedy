require 'atcoder_greedy'
require 'atcoder_greedy/command'
require 'atcoder_greedy/lib/atcoder'

def get_language_id(extname, contest_date)
  # TODO: 日付の検証
  if contest_date < Date.new(2015, 3, 1)
    # ABC001 ~ ABC019
    case extname
      when '.rb'
        # Ruby (1.9.3)
        9
      when '.cpp'
        # C++11 (GCC 4.8.1)
        10
      when '.c'
        # C (GCC 4.6.4)
        13
      when '.hs'
        # Haskell (GHC 7.4.1)
        11
      else
        raise "Unknown extname: #{extname}"
    end
  elsif contest_date < Date.new(2016, 3, 20)
    # ABC020 ~ ABC 034
    case extname
      when '.rb'
        # Ruby (2.1.5p273)
        2010
      when '.cpp'
        # C++11 (GCC 4.9.2)
        2003
      when '.c'
        # C (GCC 4.9.2)
        2001
      when '.hs'
        # Haskell (Haskell Platform 2014.2.0.0)
        2033
      else
        raise "Unknown extname: #{extname}"
    end
  else
    # ABC035~
    case extname
      when '.rb'
        # Ruby (2.3.0)
        3024
      when '.cpp'
        # C++14 (GCC 5.3.0)
        3003
      when '.c'
        # C (GCC 5.3.0)
        3002
      when '.hs'
        # Haskell (GHC 7.10)
        3014
      else
        raise "Unknown extname: #{extname}"
    end
  end
end

module AtcoderGreedy
  class Command < Thor
    desc 'submit [SUBMIT_FILE]', 'submit your solution'

    # TODO: 提出言語のオプション
    map 's' => 'submit'
    def submit(submit_file)
      print "Submit [#{submit_file}] ... "
      contest_info = YAML.load_file("./.contest_info.yml")
      problem = File.basename(submit_file, '.*')
      if contest_info[:task].include?(:"#{problem}")
        task_id = contest_info[:task][:"#{problem}"][:id]
      else
        raise "Unknown problem: #{problem}"
      end

      atcoder = Atcoder.new
      atcoder.login(contest_info[:url])

      submit_url = contest_info[:url] + "/submit?task_id=#{task_id}"
      atcoder.agent.get(submit_url) do |page|
        p = page.form_with(action: "/submit?task_id=#{task_id}") do |f|
          f.field_with(name: 'source_code').value = File.open(submit_file).read
          f.field_with(name: 'task_id').value = task_id

          # 日付情報が書いていなかった場合取得する
          if contest_info[:date].nil?
            contest_info[:date] = Date.parse(page.xpath('//time').first.text)
            File.open("./.contest_info.yml", 'w') do |f|
              f.puts contest_info.to_yaml
            end
          end
          f.field_with(name: "language_id_#{task_id}").value =
              get_language_id(File.extname(submit_file), contest_info[:date])
        end.submit
        puts 'Done!'
        Launchy.open p.uri
      end
    end
  end
end
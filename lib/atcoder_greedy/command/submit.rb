require 'atcoder_greedy'
require 'atcoder_greedy/command'

def get_language_id(extname)
  case extname
    when '.rb'
      2010
    when '.cpp'
      2003
    when '.c'
      2001
    else
      raise "Unknown extname: #{extname}"
  end
end

module AtcoderGreedy
  class Command < Thor
    desc 'submit [SUBMIT_FILE]', 'submit your solution'

    def submit(submit_file)
      print "Submit [#{submit_file}] ... "
      contest_info = YAML.load_file("./.contest_info.yml")
      problem = File.basename(submit_file, '.*')
      if contest_info[:task].include?(:"#{problem}")
        task_id = contest_info[:task][:"#{problem}"][:id]
      else
        raise "Unknown problem: #{problem}"
      end

      submit_url = contest_info[:url] + '/submit?task_id=' + task_id
      agent = Mechanize.new
      agent.get(contest_info[:url] + '/login') do |page|
        response = page.form_with(action: '/login') do |f|
          f.field_with(name: 'name').value = AtcoderGreedy.config[:user_id]
          f.field_with(name: 'password').value = AtcoderGreedy.config[:password]
        end.submit
      end

      agent.get(submit_url) do |page|
        p = page.form_with(action: "/submit?task_id=#{task_id}") do |f|
          f.field_with(name: 'source_code').value = File.open(submit_file).read
          f.field_with(name: 'task_id').value = task_id
          f.field_with(name: "language_id_#{task_id}").value = get_language_id(File.extname(submit_file))
        end.submit
        puts "Done!"
        Launchy.open p.uri
      end
    end
  end
end
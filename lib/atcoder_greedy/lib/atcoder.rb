require 'mechanize'
require 'atcoder_greedy'

class Atcoder
  attr_accessor :agent
  def initialize
    @agent = Mechanize.new
  end

  def login(url)
    print 'Login ... '
    if AtcoderGreedy.config[:user_id].nil? || AtcoderGreedy.config[:user_id].size == 0
      puts 'You still not set account info.'
      print 'Input User id: '
      user_id = $stdin.gets.chomp!
      print 'Input password: '
      password = $stdin.gets.chomp!
    else
      user_id = AtcoderGreedy.config[:user_id]
      password = AtcoderGreedy.config[:password]
    end

    response = nil
    @agent.get(url + '/login') do |page|
      response = page.form_with(action: '/login') do |f|
        f.field_with(name: 'name').value = user_id
        f.field_with(name: 'password').value = password
      end.submit
      raise 'Login error' unless response.response['x-imojudge-simpleauth'] == 'Passed'
    end
    puts 'Done!'
    response
  end
end
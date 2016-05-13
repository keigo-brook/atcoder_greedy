require 'spec_helper'
require 'atcoder_greedy'
describe 'Command::create' do
  after(:all) do
    if Dir.exist?("./abc003")
      FileUtils.rm_rf('./abc003')
    end
  end
  subject { ->(url) { AtcoderGreedy::Command.new.create(url) } }
  it 'should create contest files' do
    allow(AtcoderGreedy).to receive(:config).and_return(
        {
            user_id: '',
            password: '',
            language: '',
            default_template: {
                rb: '',
                cpp: '',
                c: '',
                py: ''
            }
        })
    # subject.call('http://abc003.contest.atcoder.jp')
    # expect("a").to exist("")
    # TODO ログイン情報どうするか考える

  end
end
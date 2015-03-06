require 'spec_helper'

describe 'myweb::default' do
  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port('80') do
    it { should be_listening.with('tcp') }
  end
end
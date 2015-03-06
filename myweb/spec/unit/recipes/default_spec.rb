#
# Cookbook Name:: myweb
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


require 'spec_helper'

describe 'myweb::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it { expect(chef_run).to install_package('nginx') }
  it { expect(chef_run).to start_service('nginx') }
end

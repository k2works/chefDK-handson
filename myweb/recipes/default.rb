#
# Cookbook Name:: myweb
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe 'nginx::default'

template '/usr/share/nginx/html/index.html' do
  owner 'www-data'
  group 'www-data'
  mode '644'
end

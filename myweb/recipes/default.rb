#
# Cookbook Name:: myweb
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
package 'nginx'

service 'nginx' do
  action [:start]
end

template '/usr/share/nginx/html/index.html' do
  owner 'www-data'
  group 'www-data'
  mode '644'
end

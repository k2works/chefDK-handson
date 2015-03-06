#
# Cookbook Name:: myweb
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
package 'nginx'

service 'nginx' do
  action [:start]
end

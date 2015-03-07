#
# Cookbook Name:: handson
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
log "Hello ChefDK Handson!"
include_recipe 'curl'
include_recipe 'chef-dk'
include_recipe 'docker'

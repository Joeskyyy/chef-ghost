#
# Cookbook Name:: ghost
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ghost-blog::install'
include_recipe 'ghost-blog::configure'
include_recipe 'ghost-blog::start'

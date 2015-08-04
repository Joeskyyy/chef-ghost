include_recipe 'nodejs'

package 'unzip'

apt_repository 'nginx' do
  uri          'ppa:nginx/stable'
  distribution node['lsb']['codename']
end

package 'nginx'

%w{nxensite nxdissite}.each do |nxscript|
    template "#{node['ghost']['nginx']['script_dir']}/#{nxscript}" do
    source "#{nxscript}.erb"
    mode '0755'
    owner 'root'
    group 'root'
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/ghost.zip" do
    source "https://ghost.org/zip/ghost-#{node['ghost']['version']}.zip"
    not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/ghost.zip") }
end

execute 'unzip' do
    user 'root'
    command "unzip #{Chef::Config[:file_cache_path]}/ghost.zip -d #{node['ghost']['install_dir']}"
    not_if { ::File.directory?(node['ghost']['install_dir']) }
end

nodejs_npm 'packages.json' do
    user 'root'
    json true
    path node['ghost']['install_dir']
    options ['--production']
end

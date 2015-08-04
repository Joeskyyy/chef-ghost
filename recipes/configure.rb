template "/etc/nginx/sites-available/#{node['ghost']['nginx']['server_name']}.conf" do
    source 'ghost.conf.erb'
    owner 'root'
    group 'root'
end

bash 'enable site config' do
    user 'root'
    cwd '/etc/nginx/sites-available/'
    code <<-EOH
    nxdissite default
    nxensite #{node['ghost']['nginx']['server_name']}.conf
    EOH
end

template '/etc/init.d/ghost' do
    source 'ghost.init.erb'
    owner 'root'
    group 'root'
    mode '0755'
end

template "#{node['ghost']['install_dir']}/config.js" do
    source 'config.js.erb'
    owner 'root'
    group 'root'
    variables(
        :url => node['ghost']['app']['server_url'],
        :port => node['ghost']['app']['port'],
        :transport => node['ghost']['app']['mail_transport_method'],
        :service => node['ghost']['app']['mail_service'],
        :user => node['ghost']['app']['mail_user'],
        :passwd => node['ghost']['app']['mail_passwd'],
        :aws_access => node['ghost']['ses']['aws_access_key'],
        :aws_secret => node['ghost']['ses']['aws_secret_key'],
        :db_type => node['ghost']['app']['db_type'],
        :db_host => node['ghost']['mysql']['host'],
        :db_user => node['ghost']['mysql']['user'],
        :db_passwd => node['ghost']['mysql']['passwd'],
        :db_name => node['ghost']['mysql']['database'],
        :charset => node['ghost']['mysql']['charset']
    )
end

template "/etc/nginx/sites-available/#{node['ghost-blog']['nginx']['server_name']}.conf" do
    source 'ghost.conf.erb'
    owner 'root'
    group 'root'
end

bash 'enable site config' do
    user 'root'
    cwd '/etc/nginx/sites-available/'
    code <<-EOH
    nxdissite default
    nxensite #{node['ghost-blog']['nginx']['server_name']}.conf
    EOH
end

template '/etc/init.d/ghost' do
    source 'ghost.init.erb'
    owner 'root'
    group 'root'
    mode '0755'
end

template "#{node['ghost-blog']['install_dir']}/config.js" do
    source 'config.js.erb'
    owner 'root'
    group 'root'
    variables(
        :url => node['ghost-blog']['app']['server_url'],
        :port => node['ghost-blog']['app']['port'],
        :transport => node['ghost-blog']['app']['mail_transport_method'],
        :service => node['ghost-blog']['app']['mail_service'],
        :user => node['ghost-blog']['app']['mail_user'],
        :passwd => node['ghost-blog']['app']['mail_passwd'],
        :aws_access => node['ghost-blog']['ses']['aws_access_key'],
        :aws_secret => node['ghost-blog']['ses']['aws_secret_key'],
        :ses_smtp_host => node['ghost-blog']['ses']['ses_smtp_host'],
        :ses_port => node['ghost-blog']['ses']['port'],
        :db_type => node['ghost-blog']['app']['db_type'],
        :db_host => node['ghost-blog']['mysql']['host'],
        :db_user => node['ghost-blog']['mysql']['user'],
        :db_passwd => node['ghost-blog']['mysql']['passwd'],
        :db_name => node['ghost-blog']['mysql']['database'],
        :charset => node['ghost-blog']['mysql']['charset']
    )
end

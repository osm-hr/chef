#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2013, OpenStreetMap Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "nginx"

resolvers = node[:networking][:nameservers].map do |resolver|
  IPAddr.new(resolver).ipv6? ? "[#{resolver}]" : resolver
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0o644
  variables :resolvers => resolvers
end

directory "/var/cache/nginx/fastcgi-cache" do
  owner "www-data"
  group "root"
  mode 0o755
  only_if { node[:nginx][:cache][:fastcgi][:enable] }
end

directory "/var/cache/nginx/proxy-cache" do
  owner "www-data"
  group "root"
  mode 0o755
  only_if { node[:nginx][:cache][:proxy][:enable] }
end

# Temporary Cleanup to remove old levels=1:2 cache after migration to 2:2:2
execute "nginx-remove-old-fastcgi-cache" do
  command "/usr/bin/find /var/cache/nginx/fastcgi-cache/ -mindepth 3 -maxdepth 3 -type f -delete"
  ignore_failure true
  only_if { node[:nginx][:cache][:fastcgi][:enable] }
end

# Temporary Cleanup to remove old levels=1:2 cache after migration to 2:2:2
execute "nginx-remove-old-proxy-cache" do
  command "/usr/bin/find /var/cache/nginx/proxy-cache/ -mindepth 3 -maxdepth 3 -type f -delete"
  ignore_failure true
  only_if { node[:nginx][:cache][:proxy][:enable] }
end

service "nginx" do
  action [:enable] # Do not start the service as config may be broken from failed chef run
  supports :status => true, :restart => true, :reload => true
  subscribes :restart, "template[/etc/nginx/nginx.conf]"
end

munin_plugin_conf "nginx" do
  template "munin.erb"
end

package "libwww-perl"

munin_plugin "nginx_request"
munin_plugin "nginx_status"

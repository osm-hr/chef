default[:exim][:local_domains] = ["localhost", "@"]
default[:exim][:relay_to_domains] = []
default[:exim][:relay_from_hosts] = ["127.0.0.1", "::1"]
default[:exim][:daemon_smtp_ports] = [25]
default[:exim][:trusted_users] = []
default[:exim][:smarthost_name] = nil
default[:exim][:smarthost_via] = "mail.openstreetmap.org:26"
default[:exim][:routes] = {}
default[:exim][:aliases][:root] = "tomh"
default[:exim][:rewrites] = []

name "ironbelly"
description "Master role applied to ironbelly"

default_attributes(
  :apt => {
    :sources => ["ubuntugis-unstable"]
  },
  :git => {
    :allowed_nodes => "*:*",
    :user => "chefrepo",
    :group => "chefrepo",
    :backup => "chef-git"
  },
  :networking => {
    :interfaces => {
      :internal_ipv4 => {
        :interface => "eth0",
        :role => :internal,
        :family => :inet,
        :address => "146.179.159.177"
      },
      :external_ipv4 => {
        :interface => "eth1",
        :role => :external,
        :family => :inet,
        :address => "193.63.75.107"
      },
      :external_ipv6 => {
        :interface => "eth1",
        :role => :external,
        :family => :inet6,
        :address => "2001:630:12:500:225:90ff:fec4:f6ef"
      }
    }
  },
  :openvpn => {
    :address => "10.0.16.2",
    :tunnels => {
      :ic2ucl => {
        :port => "1194",
        :mode => "server",
        :peer => {
          :host => "ridley.openstreetmap.org"
        }
      }
    }
  },
  :rsyncd => {
    :modules => {
      :hosts => {
        :comment => "Host data",
        :path => "/home/hosts",
        :read_only => true,
        :write_only => false,
        :list => false,
        :uid => "tomh",
        :gid => "tomh",
        :transfer_logging => false,
        :hosts_allow => [
          "212.110.172.32",                      # shenron
          "2001:41c9:1:400::32",                 # shenron
          "212.159.112.221"                      # grant
        ]
      },
      :logs => {
        :comment => "Log files",
        :path => "/store/logs",
        :read_only => false,
        :write_only => true,
        :list => false,
        :uid => "www-data",
        :gid => "www-data",
        :transfer_logging => false,
        :hosts_allow => [
          "128.40.168.0/24",      # ucl external (wates)
          "128.40.45.192/27",     # ucl external (wolfson)
          "146.179.159.160/27",   # ic internal
          "193.63.75.96/27",      # ic external
          "2001:630:12:500::/64", # ic external
          "127.0.0.0/8",          # localhost
          "::1"                   # localhost
        ],
        :nodes_allow => "roles:tilecache"
      }
    }
  }
)

run_list(
  "role[ic]",
  "role[gateway]",
  "role[chef-server]",
  "role[chef-repository]",
  "role[web-storage]",
  "role[supybot]",
  "role[backup]",
  "role[stats]",
  "role[planet]",
  "role[planetdump]",
  "recipe[rsyncd]",
  "recipe[openvpn]",
  "recipe[git::server]",
  "recipe[tilelog]"
)

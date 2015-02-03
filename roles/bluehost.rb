name "bluehost"
description "Role applied to all servers at Bluehost"

default_attributes(
  :networking => {
    :nameservers => ["8.8.8.8", "8.8.4.4"],
    :roles => {
      :external => {
        :zone => "bh"
      }
    }
  }
)

override_attributes(
  :ntp => {
    :servers => ["ntp.bluehost.com"]
  }
)

run_list(
  "role[us]"
)

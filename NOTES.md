These notes may be usefull for future releases. 

It is possible to add the Jenkins service to the to a firewalld zone using the follwing augeas resource.
```
  augeas { 'jenkinstest' :
    context => "/files/usr/lib/firewalld/zones/public.xml",
    lens    => "Xml.lns",
    incl    => "/usr/lib/firewalld/zones/public.xml",
    onlyif  => "get zone/service[last()]/#attribute/name != 'jenkins'",
    changes => [
      'set zone/#text[last()+1] "  "',
      'set zone/service[last()+1] "#empty"',
      'set zone/service[last()]/#attribute/name "jenkins"'],
    }
```
However this wasn't used as the function is duplactaed by the ```firewall-cmd``` command which is required to get the zone fully functioning. 


On some ports ipv6 was enabled, if this module is to be run on a port that is configured for ipv6 by default then consider adding this code.
```
    augeas { "sysctl":
    context => "/files/etc/sysctl.conf",
    changes => [
      #"set net.ipv6.conf.all.disable_ipv6 1",
      "set net.ipv6.conf.$jenkinsport.disable_ipv6 1",
      "set net.ipv6.conf.default.disable_ipv6 1",
    ],
    notify  => Exec['sysctl']
  }

  exec { "sysctl":
    alias       => "sysctl",
    refreshonly => true,
    subscribe   => File["sysctl_conf"],
  }
```
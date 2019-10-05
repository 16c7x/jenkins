# This class will setup a Jenkins server on the desired port.
#
# It installs the rpms, ensures the required services are running,
# configures firewalld to accept incomming traffic for Jenkins.
#
# Author
# Andrew Jones - andrewj100@gmail.com - https://github.com/16c7x/

class jenkins  (
  String  $jenkinsport ='8000',
) {

###############################
# Configure the yum repo and install the required packages as specified
# in the Jenkins install guide.
  yumrepo { 'jenkins' :
    name     => 'Jenkins',
    baseurl  => 'http://pkg.jenkins.io/redhat',
    gpgcheck => true,
    gpgkey   => 'https://jenkins-ci.org/redhat/jenkins-ci.org.key',
  }

  package { 'java' : ensure => 'installed'}
  package {'jenkins' : ensure => 'installed'}

###############################
# Install and configure Jenkins
  service { 'jenkins' :
    ensure => running,
    #enable => true,  <- TEST THIS
  }

  augeas { 'jenkins_port' :
    context => "/files/etc/sysconfig/jenkins",
    changes => "set JENKINS_PORT $jenkinsport",
    onlyif  => "match JENKINS_PORT[.='$jenkinsport'] size == 0",
    notify  =>  Service[jenkins],
    }

###############################
# Firewalld needs to expose the port to external connections.
# I could add - service {'firewalld' ; ensure => 'stopped', }
# but that's a bit excessive.
# It's enabled by default we need to define it so we can refresh it  
  service { 'firewalld' :
    ensure => running,
    enable => true,
  }

  file { 'jenkinsservice' :
    ensure  => file,
    content => template('jenkins/jenkins.xml.erb' ),
    path    => '/usr/lib/firewalld/services/jenkins.xml',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    notify  => Exec['firewallreload'], # I can't see another way to do this.
  }

  exec { 'firewallreload' :
    command     => 'firewall-cmd --reload',
    path        => ['/usr/bin', '/usr/sbin', '/sbin'],
    refreshonly => true,
    notify      => Exec['addfirewallservice'],
  }

  exec { 'addfirewallservice' :
    command     => 'firewall-cmd --zone=public --add-service=jenkins --permanent',
    path        => ['/usr/bin', '/usr/sbin', '/sbin'],
    refreshonly => true,
    notify      => Service['firewalld'],
  }



  # IPv6 is trying to use 8080
  augeas { "sysctl":
    context => "/files/etc/sysctl.conf",
    changes => [
      #"set net.ipv6.conf.all.disable_ipv6 1",
      "set net.ipv6.conf.$jenkinsport.disable_ipv6 1",
      "set net.ipv6.conf.default.disable_ipv6 1",
    ],
  }

  #exec { "sysctl -p":
  #  alias       => "sysctl",
  #  refreshonly => true,
  #  subscribe   => File["sysctl_conf"],
  #}

}

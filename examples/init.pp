# This is to test the code, you can change the port if you want.
# Note: other ports may be in use by other processes or configured 
# for ipv6 in which case they will not work. 

  class { 'jenkins':
    jenkinsport => '8000',
  }

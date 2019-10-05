# This is to test the code, you can change the port if you want.
# But if the port is already in use or has been grabbed by ipv6 
# it may not work.
  class { 'jenkins':
    jenkinsport => '8000',
  }

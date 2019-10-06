# firewalldzone.rb
# Some ruby code to execute a command on the command line
# to return firewalld's default zone. 

Facter.add('firewalldzone') do
    setcode do
      Facter::Core::Execution.exec('/bin/firewall-cmd --get-default-zone')
    end
  end
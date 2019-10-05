# Steps to Apply the solution
Prerequisites:
  1. Vargrant must be installed, in this instance I used Virtualbox as a provider.
  2. On the command line run ```vagrant box add puppetlabs/centos-7.2-64-puppet```.

Applting the solution:
  1.   



## Describe the most difficult hurdle you had to overcome in implementing your solution.
The most diffuicult hurdlw was managing firewalld.
I'd successfully created a jenkins service in /usr/lib/firewalld/services/.
I've created a block of code that would add the service to the the public zone, see below;

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

But there was no way of 


## Please explain why the requirement (d) above is important.
If it requires manual intevention it's not fully automated.
Manual tasks can sometimes be done differently by different engineers or sometimes missed entirely.

## Where did you go to find information to help you?
To get Vagrant up and running I used
    https://www.youtube.com/watch?v=Jkf5g7L9dSE
    https://gist.github.com/learncodeacademy/5f84705f2229f14d758d

For the installation of Jenkins I looked here:
    https://jenkins.io/doc/book/installing/#fedora

For generap Puppet resource reference I used;
    https://puppet.com/docs/puppet/5.5/type.html

To understand the requirements of firewalld I used these pages;
    https://firewalld.org/documentation/howto/add-a-service.html
    https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7

To set the Jenkins port using Augeas I used;
    https://puppet.com/docs/puppet/5.5/resources_augeas.html#a-better-way
    https://ask.puppet.com/question/4071/use-augeas-provider-to-edit-xml-file/



## Briefly explain what automation means to you, and why it is important to an organization's infrastructure design strategy.
Automation means instead of doing the same thing 

Automation - repeatable tasks, done the same every time, consistency.

Delivering things faster. 


cp /usr/lib/firewalld/zones/public.xml /tmp/foo.xml

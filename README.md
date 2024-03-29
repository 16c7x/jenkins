# Steps to Apply the solution
## Prerequisites:
  1. This was tested on Vargant using the **centos-7.2-64-puppet** machine with Virtualbox configured as a provider.
  2. You will need an ssh client to access the Vagrant machine, I used **Git Bash** available from [Git SCM](https://git-scm.com/), this can be used for running Vagrant commands as well as ssh'ing into the Vagrant machine.
  3. You'll need the Jenkins project submitted via [appgreenhouse](https://app.greenhouse.io), it's also available [here](https://github.com/16c7x/jenkins). 
  4. Your machine will need internet access to pull down the Vagrant machine and also to pull the Java and Jenkins packages during the running of the module. 

## Applying the solution:
  1. On the command line run ```vagrant box add puppetlabs/centos-7.2-64-puppet``` to pull the required Vagrant machine
  2. Navigate to the project directory and run ```vagrant up```.
  3. To ssh into the Vagrant machine run ```vagrant ssh```.
  4. To run Puppet you'll need to be root so run ```sudo su -```.
  5. To apply the Puppet module run ```puppet apply /etc/puppetlabs/code/environments/production/modules/jenkins/examples/init.pp```.
  6. To test, open up a web browser on your machine and go to [http://localhost:8000](http://localhost:8000).

## Notes:
  1. The **Vagrantfile** is in the root of the Jenkins project directory structure. 
  1. The project directory is mapped into the vagrant machine using this line ```config.vm.synced_folder ".", "/etc/puppetlabs/code/environments/production/modules/jenkins"``` in the **Vagrantfile**.
  2. The port jenkins is on is exposed using this line ```config.vm.network "forwarded_port", guest: 8000, host: 8000``` in the **Vagrantfile**. 
  3. If you want to switch Jenkins to operate on a different port then you can do so by changing the port number in **/etc/puppetlabs/code/environments/production/modules/jenkins/examples/init.pp**, you will also need to update the **Vagrantfile**.

## Describe the most difficult hurdle you had to overcome in implementing your solution.
The most difficult hurdle was managing firewalld.
A simple solution would have been to add the following to the Puppet module.
```
  service { 'firewalld' :
    ensure => stopped,
    enable => false,  
  }
```
But globaly switching security off on a server is generaly considered bad practice.
All the documentation I found on **firewalld** suggestred there was no way of configuring it without using the ```firewall-cmd ``` command line command which would result in having to use an exec command in the Puppet module. I try to avoid using the ```exec``` resource type in Puppet because Puppet is a declerative language and an ```exec``` to run a command line is scripting. In this case though there was no other option. 

## Please explain why the requirement (d) above is important.
If it requires manual intervention it's not fully automated.

## Where did you go to find information to help you?
To get Vagrant up and running I used
- https://www.youtube.com/watch?v=Jkf5g7L9dSE
- https://gist.github.com/learncodeacademy/5f84705f2229f14d758d

For the installation of Jenkins I looked here:
- https://jenkins.io/doc/book/installing/#fedora

For general Puppet resource reference I used;
- https://puppet.com/docs/puppet/5.5/type.html

To understand the requirements of firewalld I used these pages;
- https://firewalld.org/documentation/howto/add-a-service.html
- https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7
- https://www.linode.com/docs/security/firewalls/introduction-to-firewalld-on-centos/

To set the Jenkins port using Augeas I used;
- https://puppet.com/docs/puppet/5.5/resources_augeas.html#a-better-way

## Briefly explain what automation means to you, and why it is important to an organization's infrastructure design strategy.
Automation means delivering applications, solutions or servers quickly and consistently.
It eliminates inconsistencies that can be introduced during a manual build through user error, poor documentation or bad habits.

Automation reduces costs, not only does it require fewer people to deploy a system, through a more reliable and consistent deployment process it can significantly reduce down time for business critical applications. 

It can rapidly improve fault finding, debugging and remediation by making it possible to exactly recreate production servers in a lab environment where bugs can be diagnosed and the impact of bug fixes tested in a safe environment. In addition, once you have developed a fix and fully tested it, you can apply that fix to your production servers in exactly the same way you applied it to your test servers. 

It allows much tighter version control in relation to your build processes. Manual build processes are often documented in Word documents, PDF's or text files, these often end up being shared via email or saved locally on a users machine where they may become out of date, or even get edited locally resulting in conflicting build processes. An automation tool such as Puppet will pull its code directly from a controlled code repository such as Gitlab or Github and it can be configured to be notified on any new code updates so it is always using the latest code that has been subject to proper change control.
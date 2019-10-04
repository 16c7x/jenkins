# Setting up a Vagrant developement system from scratch.
1. I haven't used Vagrant before, this [Youtube](https://www.youtube.com/watch?v=Jkf5g7L9dSE) really helped me get started as did [this](https://gist.github.com/learncodeacademy/5f84705f2229f14d758d). 
2. Pull the required Vagrant box ```vagrant box add puppetlabs/centos-7.2-64-puppet```.
3. Create a Vagrant project directory and initialise it with ```vagrant init puppetlabs/centos-7.2-64-puppet```.
4. Using the PDK create a new module in this directory, if you don't yet have the PDK you can download it [here](https://puppet.com/download-puppet-development-kit), we're going to get Vagrant to sync this into our Vagrant box. In this instance I've created a module called **jenkins** and we'll map this through by adding this line to our Vagrantfile ```config.vm.synced_folder "jenkins", "/etc/puppetlabs/code/environments/production/modules/jenkins"```. Now we can edit the module using a user friendly IDE instead of having to use vi. **NOTE:** The centos-7.2-64-puppet box comes with a default module path /etc/puppetlabs/code/modules/ if you put your code there it won't run, you need to include environments/production in that path.
5. Startup the new machine using ```vagrant up``` (you must be in the Vagrant project directory for this to work).
6. Then ssh in using ```vagrant ssh```.
7. Then check the directory is there;
```
$ vagrant ssh
Last login: Wed Oct  2 18:33:19 2019 from 10.0.2.2
[vagrant@localhost ~]$ cd /etc/puppetlabs/code/environments/production/modules/jenkins
[vagrant@localhost jenkins]$ ls
appveyor.yml  data      files    Gemfile.lock  manifests      Rakefile   spec   templates
CHANGELOG.md  examples  Gemfile  hiera.yaml    metadata.json  README.md  tasks
[vagrant@localhost jenkins]$
```

# Jenkins installation 
The first place to look is [here](https://jenkins.io/doc/book/installing/#fedora).
1. We're going to need to pull down Jenkins and Java 


Things to look at
https://www.thegeekdiary.com/centos-rhel-7-how-to-disable-ipv6/
https://stackoverflow.com/questions/37949370/unable-to-access-jenkins-from-browser-on-windows

puppet apply /etc/puppetlabs/code/environments/production/modules/jenkins/examples/init.pp --debug




## Describe the most difficult hurdle you had to overcome in implementing your solution.
I've never used used Vagrant before so first I had to install that and learn how to use it.
I had some diffuiculty setting up firewalld, it's not something that get's used often in my current role. I don't like ising exec in Puppet code, I spent a lot of effort in to trying to avoid this but in the case of firewalld I could not find a suitable alternative.  

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


## Briefly explain what automation means to you, and why it is important to an organization's infrastructure design strategy.
Automation means instead of doing the same thing 

Automation - repeatable tasks, done the same every time, consistency.

Delivering things faster. 




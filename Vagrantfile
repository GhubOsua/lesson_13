# -*- mode: ruby -*-
# vim: set ft=ruby :
ENV["LC_ALL"] = "en_US.UTF-8"


Vagrant.configure("2") do |config|
config.vm.box = "centos/7"
config.vm.hostname = "lesson13"
	config.vm.network "private_network", ip: "192.168.11.150"
	#config.vm.provision "shell", path: "lesson_10.sh"
	config.vm.define "lesson13"
	config.vm.provider "virtualbox" do |vb|
		vb.gui=false
		vb.memory = 2048
		vb.cpus = 2
		#vb.customize ['createhd', '--filename', disk, '--size', 1 * 1024]
		#vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
		#vb.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
               end

	#config.vm.synced_folder "/home/......", "/vagrant", type: "rsync"
	config.vm.provision "shell", path: "lesson_13.sh"
end

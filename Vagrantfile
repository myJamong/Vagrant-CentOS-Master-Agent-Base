# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'json'

file = File.read('properties.json')
props = JSON.parse(file)

Vagrant_API_Version = "2"
Vagrant.configure(Vagrant_API_Version) do |config|
  props['nodes'].each do |node|
    config.vm.define:"#{node['vm_define']}" do |cfg|
      config.vm.box = "centos/7"
      cfg.vbguest.auto_update = false
      cfg.vm.provider:virtualbox do |vb|
        vb.name="#{node['vb_name']}"
        vb.customize ["modifyvm", :id, "--cpus",1]
        vb.customize ["modifyvm", :id, "--memory",1024]
      end
      cfg.vm.host_name="#{node['hostname']}"
      cfg.vm.synced_folder ".", "/vagrant", disabled:true
      cfg.vm.network "public_network", ip: "#{node['ip']}", bridge: "en4: Apple USB Ethernet"
      cfg.vm.network "forwarded_port", guest: 22, host:node['ssh_forward'], auto_correct: false, id: "ssh"
      cfg.vm.provision "file", source: "properties.json", destination: "properties.json"
      cfg.vm.provision "shell", path: "all_settings.sh"
    end
  end

  #master
  config.vm.define:"master" do |cfg|
    config.vm.box = "centos/7"
    cfg.vbguest.auto_update = false
    cfg.vm.provider:virtualbox do |vb|
      vb.name="CentOS-master"
      vb.customize ["modifyvm", :id, "--cpus",2]
      vb.customize ["modifyvm", :id, "--memory",4096]
    end
    cfg.vm.host_name=props['master']['hostname']
    cfg.vm.synced_folder ".", "/vagrant", disabled:true
    cfg.vm.network "public_network", ip: props['master']['ip'], bridge: "en4: Apple USB Ethernet"
    cfg.vm.network "forwarded_port", guest: 22, host:props['master']['ssh_forward'], auto_correct: false, id: "ssh"
      cfg.vm.provision "file", source: "properties.json", destination: "properties.json"
    cfg.vm.provision "shell", path: "all_settings.sh"
    cfg.vm.provision "shell", path: "nodes_ssh_key_settings.sh"
  end
end

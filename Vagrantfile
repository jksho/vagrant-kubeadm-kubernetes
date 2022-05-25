Vagrant.configure("2") do |config|
    config.vm.provision "shell", inline: <<-SHELL
        apt-get update -y
        echo "192.168.56.10  master-node" >> /etc/hosts
        echo "192.168.56.11  worker-node01" >> /etc/hosts
        echo "192.168.56.12  worker-node02" >> /etc/hosts
        echo "192.168.56.13  worker-node03" >> /etc/hosts
    SHELL
    
    config.vm.define "master" do |master|
      master.vm.box = "bento/ubuntu-20.04"
      master.vm.hostname = "master-node"
      master.vm.network "private_network", ip: "192.168.56.10"
      master.vm.provider "virtualbox" do |vb|
          vb.memory = 8192
          vb.cpus = 4
      end
      master.vm.provision "shell", path: "scripts/common.sh"
      master.vm.provision "shell", path: "scripts/master.sh"
    end

    (1..3).each do |i|
  
    config.vm.define "node0#{i}" do |node|
      node.vm.box = "bento/ubuntu-20.04"
      node.vm.hostname = "worker-node#{i}"
      node.vm.network "private_network", ip: "192.168.56.10#{i}"
      node.vm.provider "virtualbox" do |vb|
          vb.memory = 4096
          vb.cpus = 2
      end
      node.vm.provision "shell", path: "scripts/common.sh"
      node.vm.provision "shell", path: "scripts/node.sh"
    end
    
    end
  end

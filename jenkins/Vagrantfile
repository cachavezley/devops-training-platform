Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "devops-training-slave"
    vb.memory = "2048"
    vb.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt update
    apt install -y apt-transport-https ca-certificates
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
    apt update
    apt install -y docker-engine
    gpasswd -a vagrant docker
    service docker start
  SHELL
end

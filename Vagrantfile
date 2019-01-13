Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provider "virtualbox" do |v|
    v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.synced_folder ".", "/srv/salt/mercurial"

  config.vm.provision "salt", minion_json_config: '{"file_client": "local"}'
  config.vm.provision "highstate", type: "shell", keep_color: true, inline: "salt-call --force-color state.apply mercurial --state-output changes"
end

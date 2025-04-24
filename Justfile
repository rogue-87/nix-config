system device:
	sudo nixos-rebuild switch --flake .#{{device}}

home user:
	home-manager switch --flake .#{{user}}

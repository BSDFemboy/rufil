.PHONY: install
install:
	gem install colorize
	gem install fileutils
	gem install find
	mkdir -p /usr/local/bin/rufil
	cp -r src/* /usr/local/bin/rufil
	chmod +x /usr/local/bin/rufil/main.rb
install-deps-apt:
  apt-get install ruby-dev -y
install-deps-pac:
  pacman -S ruby --noconfirm
install-deps-emrg:
  emerge dev-lang/ruby -y

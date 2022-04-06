all:
	cp rcrc ~/.rcrc
	echo "DOTFILES_DIRS=\"$(shell pwd)\"" >> ~/.rcrc
	rcup

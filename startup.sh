#!/bin/bash

# Initialize ccache if needed
if [ ! -f ${CCACHE_DIR}/ccache.conf ]; then
	sudo mkdir /srv/ccache
	sudo touch /srv/ccache/ccache.conf
	echo "Initializing ccache in /srv/ccache..."
	sudo ccache -M ${CCACHE_SIZE}
fi

# in Docker, the USER variable is unset by default
# but some programs (like jack toolchain) rely on it
export USER="$(whoami)"

# Launch tmux session
/bin/bash

sudo su emanuel /home/emanuel/.bashrc

sudo usermod -d /home/emanuel emanuel
sudo usermod --shell /bin/bash emanuel

sudo useradd -m kamila
sudo usermod -d /home/kamila kamila
sudo usermod --shell /bin/bash kamila

sudo useradd -m tuan
sudo usermod -d /home/tuan tuan
sudo usermod --shell /bin/bash tuan

sudo useradd -m next
sudo usermod -d /home/next next
sudo usermod --shell /bin/bash next

sudo chown -R emanuel:emanuel /home/emanuel
sudo chown -R tuan:tuan /home/tuan
sudo chown -R kamila:kamila /home/kamila
sudo chown -R next:next /home/next

sudo /etc/init.d/ssh start
tail -f /dev/null
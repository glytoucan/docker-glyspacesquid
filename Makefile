build:
	sudo docker.io build -t aoki/glyspacesquid .

buildpull:
	sudo docker.io build --pull=true -t aoki/glyspacesquid .

buildnocache:
	sudo docker.io build --no-cache=true -t aoki/glyspacesquid .

install:

#run glytoucan
run:
	sudo docker.io run -h cache.glytoucan.org -p 3128:3128 -p 3180:80 --link glyspace_bluetree:glyspace.glytoucan.org --name="glyspacesquid_bluetree" -d aoki/glyspacesquid

bash:
	sudo docker.io run -h cache.glytoucan.org --link glyspace_bluetree:glyspace.glytoucan.org -it -p 3129:3128 -p 3181:80 -v /tmp/glyspacesquid:/tmp aoki/glyspacesquid /bin/bash

backup:
	sudo docker run --rm --volumes-from glyspacesquid_bluetree -t -i busybox sh

clean: stop rm build run
	echo "clean"

cleanall: rmdir clean
	echo "clean"

rmdir: 
	sudo rm -rf /opt/glytoucan/*

setup:
	sudo ./setup.sh

ps:
	sudo docker.io ps

stop:
	sudo docker.io stop glyspacesquid_bluetree

rm:
	sudo docker.io rm glyspacesquid_bluetree

ip:
	sudo docker.io inspect -f "{{ .NetworkSettings.IPAddress }}" glyspacesquid_bluetree

ssh:
#	ssh -i /usr/local/share/baseimage-docker/insecure_key root@172.17.0.8
	sudo docker-ssh glyspacesquid_bluetree

restart:
	sudo docker.io restart glyspacesquid_bluetree

logs:
	sudo docker.io logs glyspacesquid_bluetree

rerun: stop rm run

dump:
	sudo docker.io export glyspacesquid_bluetree > glyspacesquid.glycoinfo.tar

load:
	cat glyspacesquid.glycoinfo.tar.gz | docker import - aoki/docker-glyspacesquid:glyspacesquid_bluetree
	
.PHONY: build run test clean

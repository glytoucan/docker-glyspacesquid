build:
	sudo docker build -t aoki/rdf.glytoucan-squid .

buildtest:
	sudo docker build -f ./Dockerfile.test -t aoki/rdf.glytoucan-squid .

buildpull:
	sudo docker build --pull=true -t aoki/rdf.glytoucan-squid .

buildnocache:
	sudo docker build --no-cache=true -t aoki/rdf.glytoucan-squid .

install:

runprod:
	sudo docker run -h cache.glytoucan.org -p 3182:80 -p 3130:3128 --link prod.glytoucan:rdf.glytoucan.org --name="prod.squid_bluetree" -v /opt/squid/log:/var/log/squid3 -d aoki/rdf.glytoucan-squid

#run glytoucan
run:
	sudo docker run -h cache.glytoucan.org -p 3180:80 -p 3128:3128 --link rdf.glytoucan:rdf.glytoucan.org -v /opt/squid/log:/var/log/squid3 --name="rdf.glytoucan-squid_bluetree" -d aoki/rdf.glytoucan-squid
	#sudo docker run -h cache.glytoucan.org -p 3180:80 -p 3128:3128 --link glyspace_bluetree:glyspace.glytoucan.org --name="rdf.glytoucan-squid_bluetree" -d aoki/rdf.glytoucan-squid

runbeta:
	sudo docker run -h cache.glytoucan.org -p 3182:80 -p 3130:3128 --link beta.glytoucan:rdf.glytoucan.org --name="rdf.glytoucan-squid_bluetree" -v /opt/squid/log:/var/log/squid3 -d aoki/beta.squid

bash:
	sudo docker run -h cache.glytoucan.org --link glyspace_bluetree:glyspace.glytoucan.org -it -p 3129:3128 -p 3181:80 -v /tmp/rdf.glytoucan-squid:/tmp aoki/rdf.glytoucan-squid /bin/bash

backup:
	sudo docker run --rm --volumes-from rdf.glytoucan-squid_bluetree -t -i busybox sh

clean: stop rm build run
	echo "clean"

cleanall: rmdir clean
	echo "clean"

rmdir: 
	sudo rm -rf /opt/glytoucan/*

setup:
	sudo ./setup.sh

ps:
	sudo docker ps

stop:
	sudo docker stop rdf.glytoucan-squid_bluetree

rm:
	sudo docker rm rdf.glytoucan-squid_bluetree

cleanprod:
	sudo docker stop prod.squid_bluetree
	sudo docker rm prod.squid_bluetree

cleanbeta:
	sudo docker stop rdf.glytoucan-squid_bluetree
	sudo docker rm rdf.glytoucan-squid_bluetree

ip:
	sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" rdf.glytoucan-squid_bluetree

ssh:
#	ssh -i /usr/local/share/baseimage-docker/insecure_key root@172.17.0.8
	sudo docker-ssh rdf.glytoucan-squid_bluetree

restart:
	sudo docker restart rdf.glytoucan-squid_bluetree

logs:
	sudo docker logs rdf.glytoucan-squid_bluetree

betalogs:
	sudo docker logs rdf.glytoucan-squid_bluetree

rerun: stop rm run

dump:
	sudo docker export rdf.glytoucan-squid_bluetree > rdf.glytoucan-squid.glycoinfo.tar

load:
	cat rdf.glytoucan-squid.glycoinfo.tar.gz | docker import - aoki/docker-rdf.glytoucan-squid:rdf.glytoucan-squid_bluetree
	
.PHONY: build run test clean

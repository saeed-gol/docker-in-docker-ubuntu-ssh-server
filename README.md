# docker-in-docker-ubuntu-ssh-server
Dockerfile for deploying docker-in-docker (dind) container with ssh connection ability

# create an image with a name (in my case image name is ubuntu.dind-ssh)
docker build -t ubuntu-dind-ssh .

# Run a container from the image, map port 2222 from host, in priviledged mode. If you don't map volume on the host path /var/run/docker.sock the docker won't work properly. 
docker run -d -p 2222:22 --name my-dind1 \
 --privileged \
 -v /var/run/docker.sock:/var/run/docker.sock \
 ubuntu-dind-ssh
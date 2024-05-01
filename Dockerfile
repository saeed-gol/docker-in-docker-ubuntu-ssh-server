# Use the official Ubuntu image as the base
FROM ubuntu

# Install SSH server, Docker CE, and other dependencies
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common openssh-server && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce && \
    mkdir /var/run/sshd && \
    echo 'root:somerootpassword' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add the initialization script
ADD init.bash /init.bash
RUN chmod +x /init.bash

# Expose the SSH port
EXPOSE 22

# Set the entry point to run the init script which can start both the SSH server and the Docker daemon
ENTRYPOINT ["/init.bash"]

# Ensure that CMD is passed to the entry script; if empty, SSH will be started by default
CMD ["/usr/sbin/sshd", "-D"]

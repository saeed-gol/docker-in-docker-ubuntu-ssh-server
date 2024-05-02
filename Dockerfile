# Use the official Ubuntu image as the base
FROM ubuntu

# Install SSH server, Docker CE, Supervisor, and other dependencies
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common openssh-server supervisor && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce && \
    mkdir /var/run/sshd && \
    echo 'root:somerootpassword' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Supervisord configuration file
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the SSH port
EXPOSE 22

# Start Supervisor to manage SSH and Docker daemon
CMD ["/usr/bin/supervisord"]

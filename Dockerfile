FROM ubuntu

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies, set capabilities, fix directory permissions for www-data, and download files in a single RUN instruction
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends apache2 wget unzip libcap2-bin ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2 && \
    chown -R www-data:www-data /var/www/html /var/run/apache2 /var/log/apache2 /var/lock/apache2 && \
    cd /var/www/html/ && \
    wget https://github.com/krishnakumarkrish/Project_Learn/archive/refs/heads/main.zip && \
    unzip main.zip && \
    cp -r Project_Learn-main/* /var/www/html/ && \
    rm -rf main.zip Project_Learn-main

# Switch to non-root user to satisfy SonarQube security rules
USER www-data

# Exposes port 80 on the container
EXPOSE 80

# Set the default application that will start when the container starts
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]

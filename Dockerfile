FROM ubuntu

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies, set capabilities, configure web files in a single RUN instruction
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends apache2 wget unzip libcap2-bin ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2 && \
    chown -R www-data:www-data /var/www/html && \
    cd /var/www/html/ && \
    wget https://github.com/krishnakumarkrish/Project_Learn/archive/refs/heads/main.zip && \
    unzip main.zip && \
    cp -r Project_Learn-main/* /var/www/html/ && \
    rm -rf main.zip Project_Learn-main

# Exposes port 80 on the container
EXPOSE 80

# Use apache2ctl to cleanly start foreground service
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

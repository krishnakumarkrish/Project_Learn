FROM ubuntu

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and libcap2-bin for non-root port binding
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends apache2 wget unzip libcap2-bin && \
    rm -rf /var/lib/apt/lists/*

# Grant non-root user (www-data) permission to bind to port 80
RUN setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2

# Set proper ownership on the web root directory
RUN chown -R www-data:www-data /var/www/html

# change directory
WORKDIR /var/www/html/

# download webfiles, extract, copy, and clean up in a single layer
RUN wget https://github.com/krishnakumarkrish/Project_Learn/archive/refs/heads/main.zip && \
    unzip main.zip && \
    cp -r Project_Learn-main/* /var/www/html/ && \
    rm -rf main.zip Project_Learn-main

# Switch to non-root user to satisfy SonarQube security rule
USER www-data

# exposes port 80 on the container
EXPOSE 80

# set the default application that will start when the container starts
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]

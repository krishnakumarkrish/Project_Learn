FROM ubuntu

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install dependencies and authbind in a single layer
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends apache2 wget unzip ca-certificates authbind && \
    rm -rf /var/lib/apt/lists/*

# 2. Configure authbind so www-data can bind to port 80
RUN mkdir -p /etc/authbind/byport && \
    touch /etc/authbind/byport/80 && \
    chmod 500 /etc/authbind/byport/80 && \
    chown -R www-data:www-data /etc/authbind/byport/80 /var/www/html

# 3. Download and set up web files
WORKDIR /var/www/html/
RUN wget https://github.com/krishnakumarkrish/Project_Learn/archive/refs/heads/main.zip && \
    unzip main.zip && \
    cp -r Project_Learn-main/* /var/www/html/ && \
    rm -rf main.zip Project_Learn-main && \
    chown -R www-data:www-data /var/www/html

# 4. Switch to non-root user to satisfy SonarQube
USER www-data

# Expose port 80
EXPOSE 80

# 5. Use authbind to launch Apache on port 80 under www-data user
CMD ["authbind", "--deep", "/usr/sbin/apache2", "-D", "FOREGROUND"]

FROM ubuntu

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install dependencies and authbind in a single layer
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends apache2 wget unzip ca-certificates authbind && \
    rm -rf /var/lib/apt/lists/*

# 2. Configure authbind permissions correctly for www-data
RUN mkdir -p /etc/authbind/byport && \
    touch /etc/authbind/byport/80 && \
    chmod 755 /etc/authbind/byport/80 && \
    chown -R www-data:www-data /etc/authbind/byport/80

# 3. Create Apache runtime directories and set permissions
RUN mkdir -p /var/run/apache2 /var/lock/apache2 /var/log/apache2 && \
    chown -R www-data:www-data /var/www/html /var/run/apache2 /var/log/apache2 /var/lock/apache2

# 4. Download and set up web files
WORKDIR /var/www/html/
RUN wget https://github.com/krishnakumarkrish/Project_Learn/archive/refs/heads/main.zip && \
    unzip main.zip && \
    cp -r Project_Learn-main/* /var/www/html/ && \
    rm -rf main.zip Project_Learn-main && \
    chown -R www-data:www-data /var/www/html

# 5. Switch to non-root user to satisfy SonarQube
USER www-data

# Expose port 80
EXPOSE 80

# 6. Use authbind to launch Apache on port 80 under www-data user
CMD ["authbind", "--deep", "/usr/sbin/apache2", "-D", "FOREGROUND"]

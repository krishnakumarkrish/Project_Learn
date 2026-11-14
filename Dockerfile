FROM ubuntu

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update -y && \
    apt install -y apache2 wget unzip

# Create a non-root user and group (e.g., webuser)
RUN groupadd -r webgroup && useradd -r -g webgroup webuser

# Change directory and set permissions for the web directory so the non-root user can write/read
WORKDIR /var/www/html/
RUN chown -R webuser:webgroup /var/www/html/ && \
    chown -R webuser:webgroup /var/log/apache2 && \
    chown -R webuser:webgroup /var/run/apache2

# Download and deploy webfiles
RUN wget https://github.com/krishnakumarkrish/Project_Learn/archive/refs/heads/main.zip && \
    unzip main.zip && \
    cp -r Project_Learn-main/* /var/www/html/ && \
    rm -rf main.zip Project_Learn-main

# Expose port 80
EXPOSE 80

# Switch to the non-root user
USER webuser

# Start Apache
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
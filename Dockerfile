FROM ubuntu

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and clean up apt cache in the same layer to reduce image size
RUN apt update -y && \
    apt install -y apache2 wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Change directory
WORKDIR /var/www/html/

# Download webfiles, extract, and clean up temporary archives in one layer
RUN wget https://github.com/krishnakumarkrish/Project_Learn/archive/refs/heads/main.zip && \
    unzip main.zip && \
    cp -r Project_Learn-main/* /var/www/html/ && \
    rm -rf main.zip Project_Learn-main

# Exposes port 80 on the container
EXPOSE 80

# --- NEW DOCKERFILE FEATURE: Health Check ---
# Docker will automatically test if your Apache web server is responding every 30 seconds
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# Start Apache in the foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
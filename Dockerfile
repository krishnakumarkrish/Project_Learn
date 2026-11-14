FROM alpine

# Install dependencies using Alpine's apk manager
RUN apk update && \
    apk add --no-cache apache2 wget unzip

# Change directory
WORKDIR /var/www/html/

# Download webfiles
RUN wget https://github.com/krishnakumarkrish/Project_Learn/archive/refs/heads/main.zip

# Unzip folder
RUN unzip main.zip

# Copy files into html directory
RUN cp -r Project_Learn-main/* /var/www/html/

# Remove unwanted folder and zip
RUN rm -rf main.zip Project_Learn-main

# Expose port 80 on the container
EXPOSE 80

# Alpine's httpd start command
CMD ["httpd", "-D", "FOREGROUND"]
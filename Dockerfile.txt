FROM ubuntu

# Install dependencies
RUN apt update -y 
RUN apt install apache2 -y
RUN apt search wget 
RUN apt install wget 
RUN apt install unzip

# change directory
WORKDIR /var/www/html/

# download webfiles
RUN wget https://github.com/krishnakumarkrish/Project_Learn/archive/refs/heads/main.zip

# unzip folder
RUN unzip main.zip

# copy files into html directory
RUN cp -r  Project_Learn-main/* /var/www/html/

# remove unwanted folder
RUN rm -rf main.zip

# exposes port 80 on the container
EXPOSE 80

# set the default application that will start when the container start
#ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
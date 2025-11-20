# Use the official Ubuntu base image
FROM ubuntu:20.04
 
# Set environment variables to avoid user interaction during package installation
ENV DEBIAN_FRONTEND=noninteractive
 
# Update package list and install Apache2
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean
 
# Set the working directory to Apache's default web root
WORKDIR /var/www/html
 
# Copy your website files into the Apache directory (optional)
# COPY ./your-website/ /var/www/html/
ADD nano.tar.gz .
 
# Expose port 80
EXPOSE 80
 
# Start Apache2 in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]

#FROM ubuntu:20.04
#ENV DEBIAN_FRONTEND=noninteractive
#RUN apt-get update && \
    #apt-get install -y apache2 && \
    #apt-get clean
#WORKDIR /var/www/html
#COPY ./cafefiles/ /var/www/html/
#ADD nano.tar.gz .
#EXPOSE 80
#CMD ["apachectl", "-D", "FOREGROUND"]

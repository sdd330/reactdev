FROM node:latest

MAINTAINER Yang Leijun <yang.leijun@gmail.com>

# Install Libs
RUN apt-get update && \
	apt-get install -y supervisor g++ libssl-dev apache2-utils libxml2-dev ruby-full rubygems-integration npm && \
	gem install sass compass && \
	npm install -g bower gulp yo --allow-root sero-cli generator-material-react generator-angular grunt-cli forever 

RUN sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

# ------------------------------------------------------------------------------
# Install Cloud9
RUN git clone https://github.com/ajaxorg/cloud9/ /cloud9
WORKDIR /cloud9
RUN npm install
RUN npm install -g sm
WORKDIR /cloud9/node_modules/ace
RUN make clean build
WORKDIR /cloud9/node_modules/packager
RUN rm -rf node_modules
RUN sm install
WORKDIR /cloud9
CMD ["make"]
RUN node ./node_modules/mappings/scripts/postinstall-notice.js

# Add supervisord conf
ADD conf/cloud9.conf /etc/supervisor/conf.d/

# Add ReactJS exercise
ADD exercise /exercise
RUN cd /exercise && npm install

# Make dockerfile and README self-contained in image
ADD . /app

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
VOLUME /workspace

# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 3131 8080

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

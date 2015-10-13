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
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh

# Tweak standlone.js conf
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js 

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

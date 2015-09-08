FROM alpine:3.2

MAINTAINER Yang Leijun <yang.leijun@gmail.com>

# Install NodeJS
RUN apk add --update bash nodejs && rm -rf /var/cache/apk/*

# Install Bower & Gulp
RUN npm install -g bower gulp yo sero-cli generator-material-react

# Define working directory.
WORKDIR /workspace

# Define default command.
CMD ["bash"]

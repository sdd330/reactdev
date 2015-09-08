FROM node:latest

MAINTAINER Yang Leijun <yang.leijun@gmail.com>

# Install Bower & Gulp
RUN npm install -g bower gulp yo --allow-root sero-cli generator-material-react

ADD exercise /exercise

# Define working directory.
WORKDIR /workspace

# Define default command.
CMD ["bash"]

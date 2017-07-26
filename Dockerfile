FROM ruby:2.3.1
MAINTAINER Fabio Napoleoni <f.napoleoni@gmail.com>
# Bundler updated version
ENV BUNDLER_VERSION 1.15.1
# Debian repository versions
ENV YARN_VERSION=0.27.5-1
# Packages repositories for yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
# Setup node
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
# Update package cache
RUN apt-get update -qq
# Install apt dependencies
RUN apt-get install -y --no-install-recommends \
  build-essential \
  nodejs yarn=${YARN_VERSION} \
  curl libssl-dev \
  git \
  unzip \
  zlib1g-dev \
  libxslt-dev \
  mysql-client
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Update bundler
RUN gem install bundler -v=${BUNDLER_VERSION}
# Phantomjs binary file
ENV PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"
# Install phantomjs and make it available in path
RUN curl -L -O https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 && \
    tar xvjf $PHANTOM_JS.tar.bz2 && \
    mv $PHANTOM_JS /usr/local/share && \
    ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin && \
    mkdir -p /root/.phantomjs/2.1.1/x86_64-linux/bin && \
    ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /root/.phantomjs/2.1.1/x86_64-linux/bin/phantomjs

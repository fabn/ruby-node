FROM ruby:2.6.2
MAINTAINER Fabio Napoleoni <f.napoleoni@gmail.com>
# Bundler updated version
ENV BUNDLER_VERSION 1.17.2
# Debian repository versions
ENV YARN_VERSION=1.19-1
# Update package cache and install https transport
RUN apt-get update -qq && apt-get -y install apt-transport-https curl
# Packages repositories for yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
# Setup node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
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

# see: https://hub.docker.com/r/robcherry/docker-chromedriver/
# Install Chrome WebDriver
RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

# Install Google Chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -yqq update && \
    apt-get -yqq install google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*
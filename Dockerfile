#DOCKER FILE RUBY SELENIUM

FROM ruby:latest
RUN apt-get update -y -q

## Install xbvf
# Source: https://github.com/keyvanfatehi/docker-chrome-xvfb

RUN apt-get install -y -q unzip xvfb

ENV DISPLAY :99

# Install Xvfb init script
#ADD docker-scripts/xvfb_init /etc/init.d/xvfb
#RUN chmod a+x /etc/init.d/xvfb
#ADD docker-scripts/xvfb_daemon /usr/bin/xvfb-daemon-run
#RUN chmod a+x /usr/bin/xvfb-daemon-run


## Install Firefox
# Source: https://github.com/jfrazelle/dockerfiles/blob/master/firefox/Dockerfile

RUN sed -i.bak 's/sid main/sid main contrib/g' /etc/apt/sources.list && \
	apt-get update && apt-get install -y \
	bzip2 \
	ca-certificates \
	curl \
	hicolor-icon-theme \
	libasound2 \
	libdbus-glib-1-2 \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# Update this as selenium-webdriver can support later versions
ENV FIREFOX_VERSION 59.0.2

RUN curl -sSL "https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2" -o /tmp/firefox.tar.bz2 \
	&& mkdir -p /opt/firefox \
	&& tar -xjf /tmp/firefox.tar.bz2 -C /opt/firefox --strip-components 1 \
	&& rm /tmp/firefox.tar.bz2* \
	&& ln -s /opt/firefox/firefox /usr/bin/firefox

#COPY docker-scripts/local.conf /etc/fonts/local.conf

# Firefox needs more libraries installed

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main restricted" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main multiverse" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --allow-unauthenticated libxcomposite1 libpango1.0-0 libgtk-3-0
#RUN apt-get install -y libpango1.0-0 libgtk-3-0


# Install geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.20.1/geckodriver-v0.20.1-linux64.tar.gz
RUN tar -xvzf geckodriver-v0.20.1-linux64.tar.gz
RUN rm geckodriver-v0.20.1-linux64.tar.gz
RUN mv geckodriver /usr/bin
RUN chmod +x /usr/bin/geckodriver


## Now do our thing
#

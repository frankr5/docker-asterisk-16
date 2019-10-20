FROM ubuntu:bionic

RUN apt update
RUN apt upgrade -y

RUN apt install -y -qq g++ make wget patch libedit-dev uuid-dev libjansson-dev libxml2-dev sqlite3 libsqlite3-dev libssl-dev

WORKDIR /usr/local/src

# Make libsrtp
RUN wget https://github.com/cisco/libsrtp/archive/v1.5.4.tar.gz
RUN tar xvzf v1.5.4.tar.gz
WORKDIR libsrtp-1.5.4
RUN ./configure
RUN make
RUN make install

WORKDIR /usr/local/src

# Getting, Building and Installing Asterisk
RUN wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16.6.1.tar.gz
RUN tar xvzf asterisk-16.6.1.tar.gz
WORKDIR asterisk-16.6.1
RUN ./configure --with-srtp
RUN make menuselect.makeopts
RUN menuselect/menuselect --disable BUILD_NATIVE --enable CORE-SOUNDS-EN-ALAW menuselect.makeopts
RUN make
RUN make install

# Test Configuration
RUN mkdir -p /etc/asterisk
COPY ./configuration/* /etc/asterisk/

WORKDIR /etc/asterisk

CMD ["asterisk", "-f"]

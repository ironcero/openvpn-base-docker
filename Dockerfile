FROM debian:jessie
MAINTAINER Ignacio Roncero Bazarra <ironcero@gmail.com>

# Proxy configuracion
ENV root_password root

# Expose port
EXPOSE 22

# Install openvpn
RUN apt-get -y update
RUN apt-get -y install openvpn openssh-client openssh-server

RUN mkdir /var/run/sshd
RUN echo root:$root_password | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

CMD echo root:$root_password | chpasswd & /usr/sbin/sshd -D

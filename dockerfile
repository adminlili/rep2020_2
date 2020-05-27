# main image for container 
FROM debian:latest

# Author of building image
MAINTAINER adminlili

ENV DEBIAN_FRONTEND=noninteractive

RUN	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y vsftpd && \
	adduser -d users -m ftpuser -c "user for remote ftp access." && \
	# let's make the password for user changed itself. :-)
	# echo "ftpuser:ftppassword" | chpasswd -e (or -c <METHOD(ex. SHA256,MD5,NONE)>)
	echo -e "ftppassword\nftppassword\n" | passwd ftpuser && \
	mkdir /home/ftpuser/ftp && \
	chown nobody:nogroup /home/ftpuser/ftp && \
	chmod a-w /home/ftpuser/ftp && \
	mkdir /home/ftpuser/ftp/files && \
	chown ftpuser:users /home/ftpuser/ftp/files && \
	echo "vsftpd test file on remote docker container." | tee \ 
		/home/ftpuser/ftp/files/test.c  && \
	service vsftpd restart 

EXPOSE 2020/tcp, 2121/tcp

COPY ["./vsftpd.conf","./vsftpd.userlist" "/etc/"]

STOPSIGNAL SIGTERM

CMD ["vsftpd", "-D", "FOREGROUND"]

HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD curl -sS 127.0.0.1 || exit 1


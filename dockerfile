# Updated to Ubuntu 22.04
FROM ubuntu:22.04
           
# Download/install WineHQ key (linking the ADD layer to the FROM layer)
# This way we don't need the wget command to get download the key file
# COMMENTED OUT BECAUSE IT DOESN'T SEEM TO WORK
# ADD --link=true https://dl.winehq.org/wine-builds/winehq.key /etc/apt/keyrings/winehq-archive.key
    
# Update package lists and install required packages
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt install -y \
	   # Uncomment only if you want to get from the wine-build repository
	   #wget \
	   software-properties-common \
	# Uncomment only if you want to get from the wine-build repository
	#&& wget -qO- https://dl.winehq.org/wine-builds/winehq.key | apt-key add -\
    #&& add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main' \
	&& apt-get update \
    && apt-get install -y \
       wine wine64 \
       #gnupg2 \
       #winbind \
       #xvfb \
       winetricks \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && winetricks msxml6
    
ENV WINEDEBUG=-all
    
# Specify a workdir, to better organize your files inside the container 
WORKDIR /root/demo

# create 64-bit wine runtime directory (one time only)
#RUN Winearch=win64 WINEPREFIX=/root/demo/.wine64 winecfg

    
# Copy files into container and link the COPY instructions
# to the previously created WORKDIR layer
COPY --link=true /demo/Win64/Release/demo.exe /root/demo
COPY --link=true startup.sh /root/startup.sh
    
# Finish up 
RUN chmod gou+x /root/startup.sh
    
EXPOSE 9000
CMD ["/root/startup.sh"]
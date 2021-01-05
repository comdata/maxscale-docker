FROM debian:testing-slim
ENV TZ=Europe/Berlin

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y cmake sudo nodejs npm \
		dpkg-dev git wget \
       build-essential libssl-dev ncurses-dev bison flex \
       perl libtool tcl tcl-dev uuid \
       uuid-dev libsqlite3-dev liblzma-dev libpam0g-dev pkg-config \
       libedit-dev libcurl4-openssl-dev libatomic1 \
       libsasl2-dev libxml2-dev libkrb5-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/mariadb-corporation/MaxScale

RUN mkdir build


RUN cat MaxScale/BUILD/install_build_deps.sh|grep -v node > build/install_build_deps.sh && chmod +x build/install_build_deps.sh && \
  		cd build && \
        ./install_build_deps.sh && \ 
 		rm -rf /var/lib/apt/lists/*

RUN cd build && \
        cmake ../MaxScale -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_MAXCTRL=N && \
# && \
        make 
# && \
#        make install
#RUN        ./postinst
FROM debian:testing-slim
ENV TZ=Europe/Berlin

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y git cmake sudo wget nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/mariadb-corporation/MaxScale

RUN mkdir build


RUN cat MaxScale/BUILD/install_build_deps.sh|grep -v node > build/install_build_deps.sh && chmod +x build/install_build_deps.sh && \
  cd build && \
        ./install_build_deps.sh

RUN cd build && \
        cmake ../MaxScale -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_MAXCTRL=N && \
        make && \
        make install
#RUN        ./postinst
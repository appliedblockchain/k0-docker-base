FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    build-essential git libprocps-dev python-markdown \
    libboost-all-dev libssl-dev libjsonrpccpp-tools libjsonrpccpp-dev \
    libgmp3-dev libsodium-dev curl && \
    ln -s /usr/include/jsoncpp/json/ /usr/include/json

RUN curl -LO https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4-Linux-x86_64.tar.gz && \
    tar -C /usr/local --strip-components 1 -xf cmake-3.13.4-Linux-x86_64.tar.gz && \
    rm cmake-3.13.4-Linux-x86_64.tar.gz

RUN curl -LO https://github.com/google/googletest/archive/release-1.8.1.tar.gz \
    && tar xvf release-1.8.1.tar.gz && cd googletest-release-1.8.1 && mkdir build && cd build && cmake .. && make && make install && cd ../.. && rm -rf release-1.8.1.tar.gz googletest-release-1.8.1

RUN git clone https://github.com/scipr-lab/libsnark.git && cd libsnark && git checkout 477c9dfd07b280e42369f82f89c08416319e24ae && git submodule update --init --recursive && cd .. && \
    cd libsnark/depends/libfqfft && mkdir build && cd build && cmake .. && make -j 2 && make install && cd ../../../.. && \
    cd libsnark && mkdir build && cd build && cmake  -DCURVE=ALT_BN128 -DWITH_PROCPS=OFF -DMULTICORE=ON -DPERFORMANCE=ON .. && make -j 2 && make install && cd ../.. && \
    rm -rf libsnark

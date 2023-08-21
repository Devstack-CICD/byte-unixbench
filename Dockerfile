FROM ubuntu:22.04

RUN apt-get update && apt install -y make gcc cpanminus

COPY UnixBench /root/unixbench/
WORKDIR /root/unixbench

RUN make
RUN cpanm Time::HiRes IO::Handle
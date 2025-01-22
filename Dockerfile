FROM debian:latest
RUN apt-get -y update
RUN apt-get -y install build-essential
RUN apt-get -y install git
RUN mkdir /root/build
WORKDIR /root/build
RUN git clone https://github.com/facebook/netconsd.git
WORKDIR /root/build/netconsd
RUN make -s

FROM debian:latest
RUN mkdir -p /app /app/modules
COPY --from=0 /root/build/netconsd/netconsd /app/
COPY --from=0 /root/build/netconsd/modules/logger.so /app/modules/
COPY --from=0 /root/build/netconsd/modules/printer.so /app/modules/
WORKDIR /app
CMD ["./netconsd","modules/logger.so"]

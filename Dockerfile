FROM ubuntu:14.04
RUN apt-get update -q && apt-get install -y gmetad ganglia-webfrontend ganglia-monitor ganglia-modules-linux ganglia-monitor-python vim rrdtool rrdcached

#mountpoints for rrd- and config files
VOLUME /var/lib/ganglia
VOLUME /etc/ganglia
VOLUME /etc/apache2

#startscript
ADD init.sh init.sh

EXPOSE 80
EXPOSE 2345/udp
EXPOSE 8648

ENTRYPOINT ["./init.sh"]
CMD [""]

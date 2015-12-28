### dockerized ganglia
ganglia server
#usage  

create the following data structure on the host:  
 * root dir: ``/srv/docker/ganglia/...``
  * gmetad config: ``...etc/ganglia/gmetad.conf``,
  * apache vhosts config (see below): ``...etc/apache2/ganglia-vhost.conf`` and
  * storage for ganglias rrd files``...lib/``.  

then start ganglia:  

```
docker run --name=ganglia -p 80:80 -p 2345:2345 -p 8648:8648 \  
--volume=/srv/docker/ganglia/etc/ganglia:/etc/ganglia \  
--volume=/srv/docker/ganglia/etc/apache2/:/etc/apache2/sites-enabled 
--volume=/srv/docker/ganglia/lib/ganglia/:/var/lib/ganglia  \ 
particlekit/ganglia
```

#vhost config
following the conventions from above your apache config should be located at ``/srv/docker/ganglia/etc/apache2/vhost.conf``:
```
<VirtualHost *:80>
    ServerAdmin admin@example.com
    ServerName example.com

    DocumentRoot /usr/share/ganglia-webfrontend

<Directory "/usr/share/ganglia-webfrontend">
        AllowOverride All
        Order allow,deny
        Allow from all
        Deny from none
</Directory>

</VirtualHost>
```

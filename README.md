## Status : Succeeded `(As of `[2d21c004c80d048b112bce5a9b296ccea7e72843](https://github.com/minoplhy/nginquic/commit/2d21c004c80d048b112bce5a9b296ccea7e72843)` at Nov 30 2022)`
# Note to Self :
This Script is using to build nginx with quic and some modules i'm currently using .

- **Please Purge existed Nginx before build**
- **Please don't named any folder in your Home Folder to 'nginquic', because this folder will be removed first once script is run**

OS : Debian

```shell
Nginx_Install=yes  # This variable is required if you want Nginx to be installed scriptibly (on Debian-based systems).
curl https://raw.githubusercontent.com/minoplhy/nginquic/ModSecurity_incl/build.sh | sudo bash
```

systemd Template:
`Location : /lib/systemd/system/nginx.service`

```
# Stop dance for nginx
# =======================
#
# ExecStop sends SIGSTOP (graceful stop) to the nginx process.
# If, after 5s (--retry QUIT/5) nginx is still running, systemd takes control
# and sends SIGTERM (fast shutdown) to the main process.
# After another 5s (TimeoutStopSec=5), and if nginx is alive, systemd sends
# SIGKILL to all the remaining processes in the process group (KillMode=mixed).
#
# nginx signals reference doc:
# http://nginx.org/en/docs/control.html
#
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target

```

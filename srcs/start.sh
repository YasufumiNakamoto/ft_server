envsubst < nginx.conf.tmpl > default
cp -f /tmp/default /etc/nginx/sites-available/default

/usr/bin/supervisord
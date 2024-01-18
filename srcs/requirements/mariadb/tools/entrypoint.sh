#!/bin/sh

EXECUTABLE="$@"

log_info() {
  echo "$@" >> /proc/1/fd/1
}

log_error() {
  echo "ERROR: $@" >> /proc/1/fd/2
}

temp_server_start() {
  log_info "Starting temporary server"
  mariadbd --skip-networking --socket=/run/mysqld/mysqld.sock --expire-logs-days=0 --loose-innodb_buffer_pool_load_at_startup=0 & ash
  TEMP_SERVER_PID=$!
  i=30
  while [ $i -gt 0 ]; do
		if su -s /bin/sh -c 'mysql --database=mysql -e "SELECT 1;"' mysql &> /dev/null; then
      log_info "Successfully started temporary server with PID: " $TEMP_SERVER_PID
			break
		fi
		sleep 1
    i=$(( i - 1 ))
	done
	if [ "$i" -eq 0 ]; then
		log_error "Failed to start the temporary server in 30 seconds"
    exit 1
	fi

}

temp_server_stop() {
  log_info "Killing temporary server with PID: " $TEMP_SERVER_PID
  kill $TEMP_SERVER_PID
  log_info "Waiting for temporary server to be die with PID: " $TEMP_SERVER_PID
	wait $TEMP_SERVER_PID
  log_info "Stopped temporary server with PID: " $TEMP_SERVER_PID
}

temp_server_start $EXECUTABLE
log_info "Running init.sql if necessary"
if [ ! -f "/var/lib/mysql/.docker_init_flag" ]; then
  mysql --protocol=socket -uroot -hlocalhost --socket=/run/mysqld/mysqld.sock < /root/init.sql
  touch /var/lib/mysql/.docker_init_flag
  log_info "Finished init.sql"
else
  log_info "init.sql has been processed previously, not doing it again."
fi
sleep 1
temp_server_stop

log_info "Starting real mariadb server"
ln -sf /proc/1/fd/2 /var/log/mysql/error.log
chown mysql:mysql /var/log/mysql/error.log
exec $EXECUTABLE

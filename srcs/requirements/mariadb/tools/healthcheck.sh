#!/bin/sh

if su -s /bin/sh -c 'mysql --database=mysql -e "SELECT 1;"' mysql; then
  exit 0
else
  exit 1
fi


#!/bin/bash

# define variables
DB_USER=root
DB_PASSWORD=password
MASTER_HOST=master.example.com
SLAVE_HOST=slave.example.com
MAIL_RECIPIENT=diduhs0@gmail.com

# check replication status
slave_io_running=$(mysql -u$DB_USER -p$DB_PASSWORD -h $SLAVE_HOST -e "SHOW SLAVE STATUS\G" | grep -c "Slave_IO_Running: Yes")
slave_sql_running=$(mysql -u$DB_USER -p$DB_PASSWORD -h $SLAVE_HOST -e "SHOW SLAVE STATUS\G" | grep -c "Slave_SQL_Running: Yes")
if [ $slave_io_running -eq 0 ] || [ $slave_sql_running -eq 0 ]; then
    # replication is stopped, send email
    echo "MySQL replication is stopped on $SLAVE_HOST" | mail -s "MySQL Replication Alert" $MAIL_RECIPIENT
fi

# check if replica server is down
if ! ping -c 1 $SLAVE_HOST > /dev/null 2>&1; then
    # replica server is down, send email
    echo "MySQL replica server is down: $SLAVE_HOST" | mail -s "MySQL Replication Alert" $MAIL_RECIPIENT
fi

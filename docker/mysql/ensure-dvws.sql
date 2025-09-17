CREATE DATABASE IF NOT EXISTS dvws_sqldb
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'dvws_user'@'%'
  IDENTIFIED BY 'dvws_pass';

GRANT ALL PRIVILEGES ON dvws_sqldb.* TO 'dvws_user'@'%';
FLUSH PRIVILEGES;


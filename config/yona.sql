create user 'yona'@'localhost' IDENTIFIED BY 'password'; 
create database yona   
DEFAULT CHARACTER SET utf8mb4   
DEFAULT COLLATE utf8mb4_bin ; 
GRANT ALL ON yona.* to 'yona'@'localhost';

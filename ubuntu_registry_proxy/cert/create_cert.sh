#!/bin/bash

# apt-get install -y openssl expect apache2-utils

echo "#########################"
echo "# create CA"

expect -c "\
  set timeout 20;\
  spawn openssl genrsa -des3 -out ca-key.pem 2048;\
  expect -re \"Enter pass phrase.*:\" ; send \"password\n\";\
  expect -re \"Verifying.*:\"         ; send \"password\n\";\
  expect eof;\
"

expect -c "\
  set timeout 20;\
  spawn openssl req -new -x509 -days 3650 -key ca-key.pem -out ca.pem
  expect -re \"Enter pass phrase.*:\"        ; send \"password\n\";\
  expect -re \"Country Name.*:\"             ; send \"AU\n\";\
  expect -re \"State or Province Name.*:\"   ; send \"State\n\";\
  expect -re \"Locality Name.*:\"            ; send \"City\n\";\
  expect -re \"Organization Name.*:\"        ; send \"Example Co. LTD\n\";\
  expect -re \"Organizational Unit Name.*:\" ; send \"P.R.\n\";\
  expect -re \"Common Name.*:\"              ; send \"example.com\n\";\
  expect -re \"Email Address.*:\"            ; send \"john@example.com\n\";\
  expect -re \"A challenge password.*:\"     ; send \"\n\";\
  expect -re \"An optional company name.*:\" ; send \"\n\";\
  expect eof;\
"

echo "#########################"
echo "# create server key"

expect -c "\
  set timeout 20;\
  spawn openssl genrsa -des3 -out server-key.pem 2048;\
  expect -re \"Enter pass phrase.*:\" ; send \"password\n\";\
  expect -re \"Verifying.*:\"         ; send \"password\n\";\
  expect eof;\
"

echo "#########################"
echo "# create sign request"

expect -c "\
  set timeout 20;\
  spawn openssl req -new -key server-key.pem -out server.csr;\
  expect -re \"Enter pass phrase.*:\"        ; send \"password\n\";\
  expect -re \"Country Name.*:\"             ; send \"AU\n\";\
  expect -re \"State or Province Name.*:\"   ; send \"State\n\";\
  expect -re \"Locality Name.*:\"            ; send \"City\n\";\
  expect -re \"Organization Name.*:\"        ; send \"Example Co. LTD\n\";\
  expect -re \"Organizational Unit Name.*:\" ; send \"P.R.\n\";\
  expect -re \"Common Name.*:\"              ; send \"example.com\n\";\
  expect -re \"Email Address.*:\"            ; send \"john@example.com\n\";\
  expect -re \"A challenge password.*:\"     ; send \"\n\";\
  expect -re \"An optional company name.*:\" ; send \"\n\";\
  expect eof;\
"

echo "#########################"
echo "# sign server key"

# serial number
echo 01 > ca.srl

expect -c "\
  set timeout 20;\
  spawn openssl x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem -out server-cert.pem;\
  expect -re \"Enter pass phrase.*:\"        ; send \"password\n\";\
  expect eof;\
"

echo "#########################"
echo "# delete pass phrase"

expect -c "\
  set timeout 20;\
  spawn openssl rsa -in server-key.pem -out server-key.pem;\
  expect \"Enter pass phrase for server-key.pem:\" ; send \"password\n\";\
  expect eof;\
"


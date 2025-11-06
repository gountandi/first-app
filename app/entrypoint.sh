#!/bin/bash

php artisan migrate

php artisan serv --host 0.0.0.0

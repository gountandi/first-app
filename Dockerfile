
#Base image
FROM php:8.1


WORKDIR /project

#
COPY app .

#Install php and extensions
RUN apt update \
&& apt-get install libfreetype-dev -y \
&& apt-get install libjpeg62-turbo-dev -y \
&& apt-get install libpng-dev -y \
&& apt-get install zip -y \
&& docker-php-ext-install bcmath pdo pgsql pdo_pgsql \
&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php -r "if (hash_file('sha384', 'composer-setup.php') === 'ed0feb545ba87161262f2d45a633e34f591ebb3381f2e0063c345ebea4d228dd0043083717770234ec00c5a9f9593792') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" \
&& php composer-setup.php \
&& php -r "unlink('composer-setup.php');" \
&& mv composer.phar /usr/local/bin/composer

#RUN docker-php-ext-install pdo_pgsql pgsql 
RUN chmod u+x /project/entrypoint.sh \
&& composer install

EXPOSE 8000

RUN php artisan key:gen  
#&& php artisan migrate 


#start main proccess
#ENTRYPOINT ["/bin/bash"]

ENTRYPOINT ["php", "artisan", "serve", "--host", "0.0.0.0"]

#!/bin/bash

# SCRIPTS Laravel
cd /home/max/www/app.xx && composer update && php artisan migrate:fresh --seed && php artisan storage:link
cd /home/max/www/food.xx && composer update && php artisan storage:link

chown -R max:www-data /home/max/www
chmod -R 2775 /home/max/www

chown -R www-data:max /home/max/www/app.xx/storage
chmod -R 775 /home/max/www/app.xx/storage

chown -R www-data:max /home/max/www/food.xx/storage
chmod -R 775 /home/max/www/food.xx/storage

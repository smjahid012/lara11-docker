setup:
	@make build
	@make up 
	@make composer-update
build:
	docker-compose build --no-cache --force-rm
down:
	docker-compose down
up:
	docker-compose up -d
ps: 
	docker-compose ps

# Run composer create-project inside the Docker container
composer-create:
	docker exec laravel-docker bash -c "composer create-project laravel/laravel ."

#Laravel: file_put_contents() failed to open stream: Permission denied
permission:
	docker exec laravel-docker bash -c "chmod -R 775 /var/www/html/bootstrap/cache && chmod -R 775 /var/www/html/storage && chown -R www-data:www-data /var/www/html/bootstrap/cache && chown -R www-data:www-data /var/www/html/storage && service apache2 reload"

composer-update:
	docker exec laravel-docker bash -c "composer update"
data:
	docker exec laravel-docker bash -c "php artisan migrate"
	docker exec laravel-docker bash -c "php artisan db:seed"
serve:
	docker exec laravel-docker bash -c "php artisan serve"


#docker image prune -a == remove unused images
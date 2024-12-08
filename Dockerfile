# PHP 8.3 ベースイメージを使用
FROM php:8.3-fpm

# 必要なシステムパッケージをインストール
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    libpng-dev \
    libpq-dev \
    && docker-php-ext-install zip pdo_mysql pdo_pgsql \
    && docker-php-ext-enable opcache

# Composer インストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 作業ディレクトリ設定
WORKDIR /var/www/html

# 必要なファイルをコピー
COPY . /var/www/html

# Laravelの依存関係インストール
RUN composer install --optimize-autoloader --no-dev

# パーミッション設定
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# エントリポイント
CMD ["php-fpm"]

# PHP-FPMのポートを公開
EXPOSE 9000

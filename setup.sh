#!/bin/bash

echo "🔧 Setting up Joomla + MySQL environment..."

# יוצרים רשת משותפת אם לא קיימת
echo "🌐 Creating Docker network 'joomla-net' (if not exists)..."
docker network inspect joomla-net >/dev/null 2>&1 || docker network create joomla-net

# כותבים את קובץ ה-docker-compose (אם לא קיים כבר)
if [ ! -f docker-compose.yml ]; then
  echo "📄 Creating docker-compose.yml..."
  cat > docker-compose.yml <<EOF
version: '3.8'

services:
  my-mysql:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: my-secret-pw
      MYSQL_DATABASE: joomla
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - joomla-net

  my-joomla:
    image: joomla
    restart: always
    ports:
      - "8080:80"
    environment:
      JOOMLA_DB_HOST: my-mysql
      JOOMLA_DB_USER: root
      JOOMLA_DB_PASSWORD: my-secret-pw
      JOOMLA_DB_NAME: joomla
    depends_on:
      - my-mysql
    networks:
      - joomla-net

volumes:
  db_data:

networks:
  joomla-net:
    external: true
EOF
else
  echo "📄 docker-compose.yml already exists. Skipping creation."
fi

# מרימים את המערכת
echo "🚀 Launching containers..."
docker-compose up -d

echo "✅ Setup complete. Joomla is available at: http://localhost:8080"

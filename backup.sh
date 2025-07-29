#!/bin/bash

echo "🛡️ Starting FULL Joomla backup..."

# מציאת שמות הקונטיינרים
DB_CONTAINER=$(docker ps --filter "name=my-mysql" --format "{{.Names}}" | head -n1)
WEB_CONTAINER=$(docker ps --filter "name=my-joomla" --format "{{.Names}}" | head -n1)

# בדיקה שהקונטיינרים קיימים
if [ -z "$DB_CONTAINER" ] || [ -z "$WEB_CONTAINER" ]; then
  echo "❌ לא נמצאו קונטיינרים של Joomla ו-MySQL. ודא שהם פועלים."
  exit 1
fi

# יצירת תיקיית שולחן העבודה אם צריך (רק ליתר ביטחון)
mkdir -p ~/Desktop

# גיבוי מסד הנתונים
echo "📦 מגבה את מסד הנתונים מתוך הקונטיינר: $DB_CONTAINER..."
docker exec "$DB_CONTAINER" sh -c 'exec mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE"' | gzip > ~/Desktop/my-joomla.backup.sql.gz

# גיבוי קבצי האתר
echo "🗂️ מגבה את קבצי האתר מתוך הקונטיינר: $WEB_CONTAINER..."
docker exec "$WEB_CONTAINER" tar czf - /var/www/html > ~/Desktop/my-joomla-files.tar.gz

echo "✅ FULL BACKUP COMPLETED — הקבצים נשמרו על שולחן העבודה"

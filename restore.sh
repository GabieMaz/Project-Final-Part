#!/bin/bash

echo "♻️ Starting FULL Joomla restore..."

# מציאת שמות הקונטיינרים (לפי השמות שלך)
DB_CONTAINER=$(docker ps --filter "name=my-mysql" --format "{{.Names}}" | head -n1)
WEB_CONTAINER=$(docker ps --filter "name=my-joomla" --format "{{.Names}}" | head -n1)

# בדיקה שהקונטיינרים אכן קיימים
if [ -z "$DB_CONTAINER" ] || [ -z "$WEB_CONTAINER" ]; then
  echo "❌ לא נמצאו קונטיינרים של Joomla ו-MySQL. ודא שהם פועלים."
  exit 1
fi

# בדיקה שהקבצים קיימים בשולחן העבודה
if [ ! -f ~/Desktop/my-joomla.backup.sql.gz ]; then
  echo "❌ קובץ גיבוי מסד נתונים לא נמצא: ~/Desktop/my-joomla.backup.sql.gz"
  exit 1
fi

if [ ! -f ~/Desktop/my-joomla-files.tar.gz ]; then
  echo "❌ קובץ גיבוי הקבצים של האתר לא נמצא: ~/Desktop/my-joomla-files.tar.gz"
  exit 1
fi

# שחזור קבצי האתר
echo "🗂️ משחזר את קבצי האתר לתוך הקונטיינר: $WEB_CONTAINER..."
docker exec -i "$WEB_CONTAINER" tar xzf - -C / < ~/Desktop/my-joomla-files.tar.gz

# שחזור מסד הנתונים
echo "📦 משחזר את מסד הנתונים לתוך הקונטיינר: $DB_CONTAINER..."
gunzip < ~/Desktop/my-joomla.backup.sql.gz | docker exec -i "$DB_CONTAINER" sh -c 'exec mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE"'

echo "✅ השחזור הושלם בהצלחה!"

#!/bin/bash

echo "🛑 עוצר את הקונטיינרים ומסיר אותם..."
docker-compose down

echo "🧹 מוחק את ה-Volume של מסד הנתונים..."
docker volume rm e8dc20f338dcba3c567bf0de721e3b748dc490129eb8033ebc496170aea6c5d

echo "✅ ניקוי הושלם!"

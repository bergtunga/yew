#/bin/sh
trunk build --release
npx tailwindcss -i ./src/resource/main.css -o assets/main.css --minify
ssh web1 "rm -f /var/www/html/*"
scp dist/* web1:/var/www/html/
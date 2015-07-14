CONTAINER=ghostku/nod32
docker run -it -p 6060:80 -v /var/nod32/:/var/www/html/ -e NOD_LANGS=1049 -e NOD_VERSIONS=v5 $CONTAINER
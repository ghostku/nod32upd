# nod32upd
NOD32 Update Mirror packed to docker container.

**build script:**

docker build -rm -t ghostku/nod32upd ./

**run script e.g.:**

1. docker run -d -p 6060:80 -v /var/nod32/:/var/www/html/ -e NOD_LANGS=1049 -e NOD_VERSIONS=v5 ghostku/nod32upd
2. docker run -it -p 6060:80 -v /var/nod32/:/var/www/html/ -e NOD_LANGS=1049 -e NOD_VERSIONS=v5 ghostku/nod32upd

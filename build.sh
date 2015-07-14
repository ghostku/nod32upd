CONTAINER=ghostku/nod32

mkdir ./docker
cp Dockerfile supervisord.conf crontab *.sh docker/
cd ./docker
docker build -rm -t $CONTAINER ./
cd ..
rm -rf ./docker
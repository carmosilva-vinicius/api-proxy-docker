docker stop api-proxy;
docker build -t api-proxy .;
docker run -d --rm -p 80:80 -p 8081:8081 -p 8082:8082 --name api-proxy api-proxy
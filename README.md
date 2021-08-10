# Local installation via Docker
1. Make sure you have installed docker
   https://www.docker.com/get-started
   
2. Build application (run only once)
```
docker build --tag image_generator .
```

3. Run from console
```
docker run -p 4567:4567 image_generator
```

4. Open http://localhost:4567

 



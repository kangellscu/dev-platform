# Build image
docker build -t workspace .

# Create & run container
docker run --rm --detach -i --network bridge --name workspace workspace

# Enter container
docker exec -i -t workspace /bin/sh

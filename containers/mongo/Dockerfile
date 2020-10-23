ARG MONGO_TAG=latest
From mongo:${MONGO_TAG}

#COPY mongo.conf /usr/local/etc/mongo/mongo.conf
VOLUME ["/data/db", "/data/configdb"]

CMD ["mongod"]

EXPOSE 27017

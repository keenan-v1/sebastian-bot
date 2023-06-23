FROM dart

WORKDIR /app

ADD bin ./bin
ADD lib ./lib
ADD pubspec.yaml ./pubspec.yaml
ADD pubspec.lock ./pubspec.lock

CMD [ "dart", "run" ]
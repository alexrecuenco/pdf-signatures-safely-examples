set -ex
set -v #verbose
TAG=${TAG:-"pdfsigning"}

# : ${A:=hello} ':' is no-op, another way to do it

docker run --rm -i -t -v ./files:/app/files --network none "$TAG" /bin/sh

set -ex
set -v #verbose

TAG=${TAG:-"pdfsigning"}

# : ${A:=hello} ':' is no-op, another way to do it
docker build . -t "$TAG"

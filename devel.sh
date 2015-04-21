#!/bin/bash
readonly IMAGE=${IMAGE:-dlin/stlinux24-sh4-glibc}
set -eufo pipefail
createimage() {
  local uid=$(id|awk -F'(' '{print $1}'|awk -F= '{print $2}')
  cat - <<EOT > Dockerfile.build
FROM $IMAGE
RUN useradd -m -u $uid $USER
EOT
  docker pull $IMAGE
  cat Dockerfile.build | docker build -t build -
}

usage(){
  cat <<EOT
Usage: $(basename $0) [init/sh/root]
  init - create personal docker image
  sh   - enter build environment as root
EOT
  exit 1
}

run(){
  docker rm -f build || true
  docker run --rm -i -t --name build \
    -w $PWD \
    -v $HOME:$HOME \
    --env EDITOR=${EDITOR:-vim} \
    --env USER=$USER \
    build \
    /bin/bash
}

main(){
  [[ $# -ne 1 ]] && usage
  case "$1" in
    init) createimage;;
    sh) run;;
    *) usage;;
  esac
}
main "$@"
# vim:et sw=2 ts=2 ai nocp sta


#!/bin/bash
readonly IMAGE=${IMAGE:-dlin/stlinux24-sh4-glibc}
#set -x ; export PS5='+\t $BASH_SOURCE:$LINENO: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
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
  init - create personal docker image 'build'
  start - start 'build' container
  rm   - force remove 'build' container
  root  - enter root
  sh  - enter normal user
EOT
  exit 1
}

chk_docker_ps() {
  local cname=$1
  local running=$(docker inspect -f '{{ .State.Running }}' $1)
  case "$running" in
    true)
      local paused=$(docker inspect -f '{{ .State.Paused }}' $1)
      [[ "$paused" = true ]] && docker unpause $1
      return 0;;
    false) docker start $1;;
    *) echo "Warn: $1 container not running, restart it"
      return 1;;
  esac
}

vm_start() {
  if ! chk_docker_ps build ; then
    docker rm -f build 2>/dev/null || true
    docker run -d -u root --name build \
      -v $HOME:$HOME \
      --env EDITOR=${EDITOR:-vim} \
      build /usr/sbin/rsyslogd -n
  fi
  docker ps | grep build
}

main(){
  [[ $# -ne 1 ]] && usage
  [[ -r /.dockerenv ]] && echo "Err: can not run in docker" && exit 1
  case "$1" in
    init) createimage;;
    start) vm_start;;
    rm) docker rm -f build;;
    root) docker exec -i -t build /bin/bash;;
    sh) docker exec -i -t build /bin/su - $USER;;
    *) usage;;
  esac
}
main "$@"
# vim:et sw=2 ts=2 ai nocp sta


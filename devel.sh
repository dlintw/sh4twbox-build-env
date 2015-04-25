#!/bin/bash
readonly IMAGE=${IMAGE:-dlin/stlinux24-sh4-glibc}
readonly NAME=${IMAGE##*/}
#set -x ; export PS5='+\t $BASH_SOURCE:$LINENO: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -eufo pipefail

createimage() {
  local uid=$(id|awk -F'(' '{print $1}'|awk -F= '{print $2}')
  cat - <<EOT > Dockerfile.$NAME
FROM $IMAGE
RUN useradd -m -u $uid $USER
EOT
  docker pull $IMAGE
  cat Dockerfile.$NAME | docker build -t $NAME -
}

usage(){
  cat <<EOT
Usage: $(basename $0) [init/sh/root]
  init - create personal docker image '$NAME'
  start - start '$NAME' container
  rm   - force remove '$NAME' container
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
  if ! chk_docker_ps $NAME ; then
    docker rm -f $NAME 2>/dev/null || true
    docker run -d -u root --name $NAME \
      -v $HOME:$HOME \
      --env EDITOR=${EDITOR:-vim} \
      $NAME /usr/sbin/rsyslogd -n
  fi
  docker ps | grep $NAME
}

main(){
  [[ $# -ne 1 ]] && usage
  [[ -r /.dockerenv ]] && echo "Err: can not run in docker" && exit 1
  case "$1" in
    init) createimage;;
    start) vm_start;;
    rm) docker rm -f $NAME;;
    root) docker exec -i -t $NAME /bin/bash;;
    sh) docker exec -i -t $NAME /bin/su - $USER;;
    *) usage;;
  esac
}
main "$@"
# vim:et sw=2 ts=2 ai nocp sta


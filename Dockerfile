FROM alpine:latest

# https://mirrors.alpinelinux.org/
RUN sed -i 's@dl-cdn.alpinelinux.org@ftp.halifax.rwth-aachen.de@g' /etc/apk/repositories

RUN apk update
RUN apk upgrade

# required liboqs 
RUN apk add --no-cache \
  gcc make linux-headers musl-dev zlib-dev zlib-static \
  python3-dev openssl-dev openssl-libs-static \
  git grep git curl libevent-dev libevent-static \
  ncurses-dev ncurses-static jq grep byacc bash \
  utf8proc-dev libutempter libutempter-dev jemalloc-static jemalloc-dev

ENV XZ_OPT=-e9
COPY build-static-tmux.sh build-static-tmux.sh
RUN chmod +x ./build-static-tmux.sh
RUN bash ./build-static-tmux.sh


#! /bin/bash

set -e

WORKSPACE=/tmp/workspace
mkdir -p $WORKSPACE
mkdir -p /work/artifact

# libutempter
cd $WORKSPACE
git clone https://github.com/altlinux/libutempter
cd libutempter/libutempter
make libutempter.a
DESTDIR=/ make install
cp libutempter.a /usr/lib/

# tmux
cd $WORKSPACE
aa=$(curl -s "https://api.github.com/repos/tmux/tmux/releases/latest" | grep -Po '"tag_name": "\K[0-9a.]+')
curl -sL $( curl -s "https://api.github.com/repos/tmux/tmux/releases/latest" | jq -r '.assets[] | select(.content_type == "application/x-gzip") | {browser_download_url}  | .browser_download_url ') | tar xv --gzip
cd tmux-$aa
CFLAGS="$CFLAGS -static" LDFLAGS="-static --static -no-pie -s" ./configure --prefix=/usr/local/tmuxmm --enable-static --enable-utempter --enable-utf8proc --enable-jemalloc
make
make install

cd /usr/local
tar vcJf ./tmuxmm.tar.xz tmuxmm

mv ./tmuxmm.tar.xz /work/artifact/

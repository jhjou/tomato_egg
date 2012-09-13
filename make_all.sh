PATH=/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/sbin:/usr/bin
PATH=$PATH:/opt/brcm/hndtools-mipsel-linux/bin
PATH=$PATH:/opt/brcm/hndtools-mipsel-uclibc/bin
export PATH

cd release/src-rt
make V1=7502 V2=-TomatoEgg n60nce

cd ..
cd ..
cp release/image/code.bin Result

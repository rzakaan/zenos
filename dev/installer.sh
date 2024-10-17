#
# dosfstools -> mks.fat
#
#
#

if [[ ${OSTYPE} == darwin* ]]; then
    brew install nasm qemu hex-fiend dosfstools mtools bochs

elif [[ ${OSTYPE} == linux* ]]; then
    sudo apt install nasm qemu hexedit

fi

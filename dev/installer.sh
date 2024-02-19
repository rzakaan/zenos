if [[ ${OSTYPE} == darwin* ]]; then
    brew install nasm qemu hex-fiend

elif [[ ${OSTYPE} == linux* ]]; then
    sudo apt install nasm qemu hexedit

fi

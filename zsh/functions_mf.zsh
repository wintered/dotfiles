#####################################################
#   TENSORFLOW                                      #
#####################################################

# tensorboard function
tb() {
    if [ "$#" -lt 1 ]
    then
        echo "usage: tb GRAPHDIRECTORY [PORTNO]"
    elif [ "$#" -lt 2 ]
    then
        /usr/bin/firefox "http://0.0.0.0:6006/" &&
        tensorboard --logdir="$1" --port "6006"
    else
        /usr/bin/firefox "http://0.0.0.0:$2/" &&
        tensorboard --logdir="$1" --port "$2"
    fi
}

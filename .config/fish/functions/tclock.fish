function tclock --wraps='tty-clock -t -c -s' --description 'alias tclock tty-clock -t -c -s'
    tty-clock -t -c -s $argv
end
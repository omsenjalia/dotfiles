function bj --description 'Launch a command detached in background'
    nohup $argv </dev/null &>/dev/null &
end

function dl --wraps=aria2c --description 'alias of aria2c'
  aria2c --dir=(xdg-user-dir DOWNLOAD) \
    --max-concurrent-downloads=3 \
    --split=16 \
    --continue \
    $argv
    # --max-connection-per-server=16 \
end

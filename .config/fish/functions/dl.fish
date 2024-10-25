function dl --wraps=aria2c --description 'alias of aria2c'
    aria2c \
      --max-concurrent-downloads=2 \
      --split=8 \
      --max-tries=0 \
      --continue \
      $argv
      # --dir=(xdg-user-dir DOWNLOAD) \
      # --max-connection-per-server=16 \
end

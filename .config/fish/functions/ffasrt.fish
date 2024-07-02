function ffasrt --description 'format farsi srt'
    sed -i -E \
        -e 's/ face="[^"]+"//g' \
        -e 's/ size="[0-9]+"//g' \
        -e 's/ي/ی/g' \
        -e 's/ه[ ‌]ی([^آ-ی]|$)/ۀ\1/g' \
        "$argv"
end

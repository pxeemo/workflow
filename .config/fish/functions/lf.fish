function lf
set tmp (mktemp)
command lf -last-dir-path=$tmp $argv
if test -f "$tmp"
set dir (cat $tmp)
rm -f $tmp
if test -d "$dir"
if test "$dir" != (pwd)
cd $dir
end
end
end
end

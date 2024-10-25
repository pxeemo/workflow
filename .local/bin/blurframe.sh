file=$1
geom=$(identify -format '%wx%h' -ping "$file")
w="${geom%x*}"
h="${geom#*x}"
unit=$(printf "%.f" $(echo "($w+$h)/2*0.1" | bc))
blur=$(printf "%.f" $(echo "$unit/2" | bc))
[ $unit -gt 50 ] || unit=50
shadow=$(printf "%.f" $(echo "$unit/6" | bc))
newgeom=$(echo "$w+$unit" | bc)x$(echo "$h+$unit" | bc)

magick "$file" \( +clone -background black -shadow "80x$shadow+0+0" \) \
    +swap -background none -layers merge +repage \
    -gravity center -background '#ffffff22' -extent "$newgeom" \
    \( \
        "$file" -resize 10% -gaussian-blur "10x$blur" \
        -resize "$newgeom^" -extent "$newgeom" \
    \) \
    +swap -composite res.png


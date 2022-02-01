#! /bin/bash
# $1 = Satellite Name
# $2 = Frequency
# $3 = FileName base
# $4 = TLE File
# $5 = EPOC start time
# $6 = Time to capture

cd /home/pi/weather

timeout $6 predict/rtlsdr_m2_lrpt_rx.py $1 $2 $3

# Winter
#medet/medet_arm ${3}.s $3 -r 68 -g 65 -b 64 -na -S

# Summer
medet/medet_arm ${3}.s $3 -r 66 -g 65 -b 64 -na -S

rm ${3}.s

if [ -f "${3}_0.bmp" ]; then
	#rm ${3}.s

	dte=`date +%H`

	# Winter
	#convert ${3}_1.bmp ${3}_1.bmp ${3}_0.bmp -combine -set colorspace sRGB ${3}.bmp
        #convert ${3}_2.bmp ${3}_2.bmp ${3}_2.bmp -combine -set colorspace sRGB -negate ${3}_ir.bmp

	# Summer
	convert ${3}_2.bmp ${3}_1.bmp ${3}_0.bmp -combine -set colorspace sRGB ${3}.bmp

	meteor_rectify/rectify.py ${3}.bmp

	# Winter only
	#meteor_rectify/rectify.py ${3}_ir.bmp

	# Rotate evening images 180 degrees
	if [ $dte -lt 13 ]; then
		convert ${3}-rectified.png -normalize -quality 90 $3.jpg

                # Winter only
		#convert ${3}_ir-rectified.png -normalize -quality 90 ${3}_ir.jpg
	else
		convert ${3}-rectified.png -rotate 180 -normalize -quality 90 $3.jpg
                # Winter only
                #convert ${3}_ir-rectified.png -rotate 180 -normalize -quality 90 ${3}_ir.jpg
	fi

	rm $3.bmp
	rm ${3}_0.bmp
	rm ${3}_1.bmp
	rm ${3}_2.bmp
	rm ${3}-rectified.png

	# Winter only
	#rm ${3}_ir.bmp
	#rm ${3}_ir-rectified.png
fi
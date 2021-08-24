#!/bin/bash
configs=<Path to configs in HOST>
templates=<Path to templates in HOST>
#xhost +local:root # for the lazy and reckless
xhost local:root
docker run -it --rm	-v $configs:/configs \
			-v $templates:/templates\
			--name ar-cvi \
			--net=ramp-iot-ld_default \
			--privileged \
			--env="DISPLAY" \
			--env="QT_X11_NO_MITSHM=1" \
			--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
			emecercelik/ar-cvi:ar-cvi_v1

xhost -local:root


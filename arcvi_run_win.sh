#!/bin/bash
ros_files=/home/emec/Desktop/projects/AR-CVI/tum_ar/tum_ar/AR-CVI/ROS-FIWARE-Integration
configs=/home/emec/Desktop/projects/AR-CVI/configs
templates=/home/emec/Desktop/projects/AR-CVI/templates
images=/home/emec/Desktop/projects/AR-CVI/images
FIWARE_ORION_ID=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' fiware-orion-ld)

docker run -it --rm 	-v $ros_files:/ros_files \
			-v $configs:/configs \
			-v $templates:/templates\
			-v $images:/images \
			--name ar-cvi \
			--net=ramp-iot-ld_default \
			--privileged \
			-e DISPLAY=host.docker.internal:0.0 -e LIBGL_ALWAYS_INDIRECT= \
			--env="FIWARE_ORION_ID=${FIWARE_ORION_ID}" \
			emecercelik/ar-cvi:ar-cvi_v1


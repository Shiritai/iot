#!/bin/bash

echo "啟動相機與校正工具"

# 啟動相機
ros2 launch zed_wrapper zed_camera.launch.py camera_model:=zedxm

# 執行相機內參校正工具
ros2 launch intrinsic_camera_calibrator calibrator.launch.xml

#!/bin/bash

# ------------------ [內參] ------------------

# 記錄指定話題
# -a 所有話題
# -o 存成檔
ros2 bag record <topic_name1> <topic_name2> ...

# 顯示紀錄之 bag 文件內容
ros2 bag info <bag_file>

# 重播紀錄
# -r 倍率
# -l, --loop 循環播放
# --clock 根據路時間順序播放
# --topics 指定重重播話題, 空白分隔
ros2 bag play <bag_file>

# 啟動相機
ros2 launch zed_wrapper zed_camera.launch.py camera_model:=zedxm

# 執行相機內參校正工具
ros2 launch intrinsic_camera_calibrator calibrator.launch.xml

# 使用校正的參數產生校正後影像之前，把檔案放入
# AUTOWARE/src/calibrated_camera_publisher/config
# 產生校正後影像
ros2 launch calibrated_camera_publisher calibrated_camera_publisher.launch.xml

# 觀察校正後影像
rviz2

# ------------------ [外參] ------------------
# 搜集校正資料
ros2 launch autoware_launch \
    autoware.launch.xml \
    map_path:=/home/jetson/autoware_map/sample-map-planning \
    vehicle_model:=sample_vehicle \
    sensor_model:=sample_sensor_kit

# 錄製資料
ros2 bag record /sensing/lidar/bf_lidar/points_raw \
    /sensing/camera/zedxm/zed_node/rgb/image_rect_color \
    /sensing/camera/zedxm/zed_node/rgb/camera_info

# 執行校正工具
ros2 launch extrinsic_calibration_manager \
    calibration.launch.xml \
    mode:=interactive \
    sensor_model:=sample_sensor_kit \
    vehicle_model:=sample_vehicle \
    vehicle_id:=default \
    camera_name:=zedxm

# 播放錄製的資料
ros2 bag play <rosbag file> --clock -l -r 0.1

# 執行手動校正工具
ros2 launch extrinsic_calibration_manager \
    calibration.launch.xml \
    mode:=manual \
    sensor_model:=sample_sensor_kit \
    vehicle_model:=sample_vehicle \
    vehicle_id:=default

# 校正完後，另外開啟 terminal，並執行以下指令儲存校正結果
ros2 topic pub /done std_msgs/Bool "data: true"


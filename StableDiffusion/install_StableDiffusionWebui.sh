#!/usr/bin/env bash

#     _____ _____   __          __  _           _   _____           _        _ _           
#    / ____|  __ \  \ \        / / | |         (_) |_   _|         | |      | | |          
#   | (___ | |  | |  \ \  /\  / /__| |__  _   _ _    | |  _ __  ___| |_ __ _| | | ___ _ __ 
#    \___ \| |  | |   \ \/  \/ / _ \ '_ \| | | | |   | | | '_ \/ __| __/ _` | | |/ _ \ '__|
#    ____) | |__| |    \  /\  /  __/ |_) | |_| | |  _| |_| | | \__ \ || (_| | | |  __/ |   
#   |_____/|_____/      \/  \/ \___|_.__/ \__,_|_| |_____|_| |_|___/\__\__,_|_|_|\___|_|   
#                                                                                          
#                                                                                          

#============================
# 前期判断开始
#============================
if [[ -z "$SUDO_USER" && $EUID -eq 0 ]]; then
  echo "脚本无法以root身份运行，请切换普通用户并使用sudo运行."
  exit 1
fi

# 判断是否为WSL环境
if grep -q Microsoft /proc/version; then
  # 如果是WSL，获取发行版名称
  distro=$(lsb_release -is)
else
  # 如果不是WSL，获取发行版名称
  distro=$(awk -F= '/^ID=/{print $2}' /etc/os-release)
fi

# 判断系统是否为Debian或Ubuntu
if [ "$distro" != "debian" ] && [ "$distro" != "ubuntu" ]; then
  echo "这个脚本只能在Debian或Ubuntu上运行."
  exit 1
fi

echo "系统符合要求，马上开始安装Stable Diffusion Webui."

#============================
# 前期判断结束
#============================

#============================
# 前置准备开始
#============================
start_time=$(date +%s)

apt-get update -y
apt-get install -y aria2 git screen wget curl

# 安装 nvidia-cudnn
apt-get install -y nvidia-cudnn

#============================
# 前置准备结束
#============================

#============================
# 准备SD Webui 开始
#============================
# 普通用户身份运行
username=$SUDO_USER

# 获取实际用户的home目录
REAL_HOME=$(eval echo ~$username)

# 在以下命令行之后的所有命令以普通用户运行
su - $username << EOF

# 下载源码
# 跟着最新版
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui $REAL_HOME/stable-diffusion-webui

# 使用指定分支，分支版本可以点仓库连接查看。和上面那个二选一，哪个不要哪个前面加#号
#git clone -b v2.0 https://github.com/camenduru/stable-diffusion-webui $REAL_HOME/stable-diffusion-webui

wget https://raw.githubusercontent.com/camenduru/stable-diffusion-webui-scripts/main/run_n_times.py -O $REAL_HOME/stable-diffusion-webui/scripts/run_n_times.py
git clone https://github.com/deforum-art/deforum-for-automatic1111-webui $REAL_HOME/stable-diffusion-webui/extensions/deforum-for-automatic1111-webui
git clone https://github.com/AlUlkesh/stable-diffusion-webui-images-browser $REAL_HOME/stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser
git clone https://github.com/camenduru/stable-diffusion-webui-huggingface $REAL_HOME/stable-diffusion-webui/extensions/stable-diffusion-webui-huggingface
git clone https://github.com/camenduru/sd-civitai-browser $REAL_HOME/stable-diffusion-webui/extensions/sd-civitai-browser
git clone https://github.com/kohya-ss/sd-webui-additional-networks $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-additional-networks
git clone https://github.com/Mikubill/sd-webui-controlnet $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet
git clone https://github.com/camenduru/openpose-editor $REAL_HOME/stable-diffusion-webui/extensions/openpose-editor
git clone https://github.com/jexom/sd-webui-depth-lib $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-depth-lib
git clone https://github.com/hnmr293/posex $REAL_HOME/stable-diffusion-webui/extensions/posex
git clone https://github.com/camenduru/sd-webui-tunnels $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-tunnels
git clone https://github.com/dtlnor/stable-diffusion-webui-localization-zh_CN $REAL_HOME/stable-diffusion-webui/extensions/stable-diffusion-webui-localization-zh_CN
git clone https://github.com/LonicaMewinsky/gif2gif $REAL_HOME/stable-diffusion-webui/extensions/gif2gif
git clone https://github.com/toshiaki1729/stable-diffusion-webui-dataset-tag-editor $REAL_HOME/stable-diffusion-webui/extensions/stable-diffusion-webui-dataset-tag-editor
git clone https://github.com/toshiaki1729/stable-diffusion-webui-text2prompt $REAL_HOME/stable-diffusion-webui/extensions/stable-diffusion-webui-text2prompt
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-pixelization $REAL_HOME/stable-diffusion-webui/extensions/stable-diffusion-webui-pixelization
git clone https://github.com/kex0/batch-face-swap $REAL_HOME/stable-diffusion-webui/extensions/batch-face-swap
git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete $REAL_HOME/stable-diffusion-webui/extensions/a1111-sd-webui-tagcomplete
git clone https://github.com/etherealxx/batchlinks-webui $REAL_HOME/stable-diffusion-webui/extensions/batchlinks-webui
git clone https://github.com/butaixianran/Stable-Diffusion-Webui-Civitai-Helper $REAL_HOME/stable-diffusion-webui/extensions/Stable-Diffusion-Webui-Civitai-Helper
git clone https://github.com/KohakuBlueleaf/a1111-sd-webui-locon $REAL_HOME/stable-diffusion-webui/extensions/a1111-sd-webui-locon
git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111 $REAL_HOME/stable-diffusion-webui/extensions/ultimate-upscale-for-automatic1111
# 仅备注区分
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-tokenizer.git $REAL_HOME/stable-diffusion-webui/extensions/stable-diffusion-webui-tokenizer
git clone https://github.com/KutsuyaYuki/ABG_extension.git $REAL_HOME/stable-diffusion-webui/extensions/ABG_extension
git clone https://github.com/klimaleksus/stable-diffusion-webui-anti-burn $REAL_HOME/stable-diffusion-webui/extensions/stable-diffusion-webui-anti-burn
git clone https://github.com/jtydhr88/sd-3dmodel-loader.git $REAL_HOME/stable-diffusion-webui/extensions/sd-3dmodel-loader
git clone https://github.com/vladmandic/sd-extension-system-info.git $REAL_HOME/stable-diffusion-webui/extensions/sd-extension-system-info
git clone https://github.com/journey-ad/sd-webui-bilingual-localization $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-bilingual-localization
git clone https://github.com/space-nuko/a1111-stable-diffusion-webui-vram-estimator.git $REAL_HOME/stable-diffusion-webui/extensions/a1111-stable-diffusion-webui-vram-estimator
git clone https://github.com/hnmr293/sd-webui-llul $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-llul


# 下载基础模型
# chilloutmix_NiPrunedFp32Fix

URL1="https://civitai.com/api/download/models/11745"
URL2="https://huggingface.co/ckpt/chilloutmix/resolve/main/chilloutmix_NiPrunedFp32Fix.safetensors"
FILE_NAME="chilloutmix_NiPrunedFp32Fix.safetensors"
DOWNLOAD_DIR="$REAL_HOME/stable-diffusion-webui/models/Stable-diffusion"

# 测试URL1是否有效
if curl --output /dev/null --silent --head --fail "$URL1"; then
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M "$URL1" -d "$DOWNLOAD_DIR" -o "$FILE_NAME"
else
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M "$URL2" -d "$DOWNLOAD_DIR" -o "$FILE_NAME"
fi


# 下载ControlNet
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_canny-fp16.safetensors -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_canny-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_depth-fp16.safetensors -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_depth-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_hed-fp16.safetensors -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_hed-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_mlsd-fp16.safetensors -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_mlsd-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_normal-fp16.safetensors -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_normal-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_openpose-fp16.safetensors -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_openpose-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_scribble-fp16.safetensors -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_scribble-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_seg-fp16.safetensors -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_seg-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/hand_pose_model.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/openpose -o hand_pose_model.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/body_pose_model.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/openpose -o body_pose_model.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/dpt_hybrid-midas-501f0c75.pt -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/midas -o dpt_hybrid-midas-501f0c75.pt
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/mlsd_large_512_fp32.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/mlsd -o mlsd_large_512_fp32.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/mlsd_tiny_512_fp32.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/mlsd -o mlsd_tiny_512_fp32.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/network-bsds500.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/hed -o network-bsds500.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/upernet_global_small.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/uniformer -o upernet_global_small.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_style_sd14v1.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_style_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_sketch_sd14v1.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_seg_sd14v1.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_seg_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_openpose_sd14v1.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_openpose_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_keypose_sd14v1.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_keypose_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_depth_sd14v1.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_color_sd14v1.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_color_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_canny_sd14v1.pth -d $REAL_HOME/stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd14v1.pth

EOF

sleep 3

end_time=$(date +%s)
duration=$((end_time - start_time))

echo "Stable Diffusion Webui 已安装完成，总共耗时: $duration 秒"

#============================
# 准备SD Webui 结束
#============================
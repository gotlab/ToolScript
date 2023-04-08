#!/usr/bin/env bash

#     _____ _____   __          __  _           _    _____ _             _            
#    / ____|  __ \  \ \        / / | |         (_)  / ____| |           | |           
#   | (___ | |  | |  \ \  /\  / /__| |__  _   _ _  | (___ | |_ __ _ _ __| |_ ___ _ __ 
#    \___ \| |  | |   \ \/  \/ / _ \ '_ \| | | | |  \___ \| __/ _` | '__| __/ _ \ '__|
#    ____) | |__| |    \  /\  /  __/ |_) | |_| | |  ____) | || (_| | |  | ||  __/ |   
#   |_____/|_____/      \/  \/ \___|_.__/ \__,_|_| |_____/ \__\__,_|_|   \__\___|_|   
#                                                                                     
#

#============================
# 前期判断开始
#============================

if [[ $EUID -eq 0 ]] || [[ ! -z $SUDO_USER ]]; then
   echo "这个脚本不能以root身份或通过sudo运行." 
   exit 1
else
   echo "马上开始启动Stable Diffusion Webui"
fi

#============================
# 前期判断结束
#============================
#
#============================
# 源码更新
#============================
#主代码更新
cd $HOME/stable-diffusion-webui
git pull

# 插件更新
cd $HOME/stable-diffusion-webui/extensions

# 遍历当前目录下所有文件夹，判断是否为git仓库，并更新源码
for dir in $(ls -d */)
do
    if [ -d "$dir.git" ]
    then
        cd $dir
        # 判断是否需要输入用户名密码
        if git pull | grep "Username\|Password"; then
            echo "Skip $dir"
        fi
        cd ..
    fi
done

#============================
# 启动Stable Diffusion webui
#============================
/usr/bin/pip3 install --upgrade pip

cd $HOME/stable-diffusion-webui/

VENV_DIR="venv"

if [ -d "$VENV_DIR" ]; then
    # 如果虚拟环境目录已经存在，则激活虚拟环境
    source "$VENV_DIR/bin/activate"
else
    # 如果虚拟环境目录不存在，则创建虚拟环境并激活
    /usr/bin/python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
fi
pip3 install --upgrade pip
pip3 install --upgrade gradio

python3 $HOME/stable-diffusion-webui/launch.py \
--share --xformers \
--enable-insecure-extension-access \
--gradio-queue \
--cloudflared \
--gradio-auth sd:sdlocalpwd233

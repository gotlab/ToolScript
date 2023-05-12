@echo off

:: 时间统计开始
for /f "tokens=1-3 delims=:.," %%a in ("%time%") do (
    set /a "start_time=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100"
)

echo.
echo 开始安装Stable Diffusion Webui 
echo.

:: 下载源码
:: 跟着最新版
rem git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui ./stable-diffusion-webui

:: 使用指定分支，分支版本可以点仓库连接查看。和上面那个二选一，哪个不要哪个前面加“rem"号

git clone -b v2.3 https://github.com/camenduru/stable-diffusion-webui ./stable-diffusion-webui/
git clone https://huggingface.co/embed/negative ./stable-diffusion-webui/embeddings/negative
git clone https://huggingface.co/embed/lora ./stable-diffusion-webui/models/Lora/positive
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/embed/upscale/resolve/main/4x-UltraSharp.pth -d ./stable-diffusion-webui/models/ESRGAN -o 4x-UltraSharp.pth
wget https://raw.githubusercontent.com/camenduru/stable-diffusion-webui-scripts/main/run_n_times.py -O ./stable-diffusion-webui/scripts/run_n_times.py
git clone https://github.com/deforum-art/deforum-for-automatic1111-webui ./stable-diffusion-webui/extensions/deforum-for-automatic1111-webui

:: 稳定版(二选一),哪个不要哪个前面加“::"号
:: git clone https://github.com/camenduru/stable-diffusion-webui-images-browser ./stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser
:: 激进版(二选一)哪个不要哪个前面加“::"号
git clone https://github.com/AlUlkesh/stable-diffusion-webui-images-browser ./stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser

git clone https://github.com/camenduru/stable-diffusion-webui-huggingface ./stable-diffusion-webui/extensions/stable-diffusion-webui-huggingface
git clone https://github.com/camenduru/sd-civitai-browser ./stable-diffusion-webui/extensions/sd-civitai-browser
git clone https://github.com/kohya-ss/sd-webui-additional-networks ./stable-diffusion-webui/extensions/sd-webui-additional-networks
git clone https://github.com/Mikubill/sd-webui-controlnet ./stable-diffusion-webui/extensions/sd-webui-controlnet
git clone https://github.com/fkunn1326/openpose-editor ./stable-diffusion-webui/extensions/openpose-editor
git clone https://github.com/jexom/sd-webui-depth-lib ./stable-diffusion-webui/extensions/sd-webui-depth-lib
git clone https://github.com/hnmr293/posex ./stable-diffusion-webui/extensions/posex
git clone https://github.com/camenduru/sd-webui-tunnels ./stable-diffusion-webui/extensions/sd-webui-tunnels
git clone https://github.com/dtlnor/stable-diffusion-webui-localization-zh_CN ./stable-diffusion-webui/extensions/stable-diffusion-webui-localization-zh_CN
git clone https://github.com/LonicaMewinsky/gif2gif ./stable-diffusion-webui/extensions/gif2gif
git clone https://github.com/toshiaki1729/stable-diffusion-webui-dataset-tag-editor ./stable-diffusion-webui/extensions/stable-diffusion-webui-dataset-tag-editor
git clone https://github.com/toshiaki1729/stable-diffusion-webui-text2prompt ./stable-diffusion-webui/extensions/stable-diffusion-webui-text2prompt
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-pixelization ./stable-diffusion-webui/extensions/stable-diffusion-webui-pixelization
git clone https://github.com/kex0/batch-face-swap ./stable-diffusion-webui/extensions/batch-face-swap
git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete ./stable-diffusion-webui/extensions/a1111-sd-webui-tagcomplete
git clone https://github.com/etherealxx/batchlinks-webui ./stable-diffusion-webui/extensions/batchlinks-webui
git clone https://github.com/butaixianran/Stable-Diffusion-Webui-Civitai-Helper ./stable-diffusion-webui/extensions/Stable-Diffusion-Webui-Civitai-Helper
git clone https://github.com/KohakuBlueleaf/a1111-sd-webui-locon ./stable-diffusion-webui/extensions/a1111-sd-webui-locon
git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111 ./stable-diffusion-webui/extensions/ultimate-upscale-for-automatic1111
:: 仅备注区分
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-tokenizer ./stable-diffusion-webui/extensions/stable-diffusion-webui-tokenizer
git clone https://github.com/KutsuyaYuki/ABG_extension ./stable-diffusion-webui/extensions/ABG_extension
git clone https://github.com/klimaleksus/stable-diffusion-webui-anti-burn ./stable-diffusion-webui/extensions/stable-diffusion-webui-anti-burn
git clone https://github.com/jtydhr88/sd-3dmodel-loader ./stable-diffusion-webui/extensions/sd-3dmodel-loader
git clone https://github.com/vladmandic/sd-extension-system-info ./stable-diffusion-webui/extensions/sd-extension-system-info
git clone https://github.com/journey-ad/sd-webui-bilingual-localization ./stable-diffusion-webui/extensions/sd-webui-bilingual-localization
git clone https://github.com/space-nuko/a1111-stable-diffusion-webui-vram-estimator ./stable-diffusion-webui/extensions/a1111-stable-diffusion-webui-vram-estimator
git clone https://github.com/hnmr293/sd-webui-llul ./stable-diffusion-webui/extensions/sd-webui-llul


:: 下载基础模型
rem chilloutmix_NiPrunedFp32Fix

set URL1="https://civitai.com/api/download/models/11745"
set URL2="https://huggingface.co/ckpt/chilloutmix/resolve/main/chilloutmix_NiPrunedFp32Fix.safetensors"
set FILE_NAME="chilloutmix_NiPrunedFp32Fix.safetensors"
set DOWNLOAD_DIR="./stable-diffusion-webui/models/Stable-diffusion"

:: 测试URL1是否可达
powershell -Command "$response = Invoke-WebRequest -Uri '%URL1%' -Method Head -ErrorVariable webError; if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 405 -or !$webError) { exit 0 } else { exit 1 }"
if %errorlevel% equ 0 (
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M "%URL1%" -d "%DOWNLOAD_DIR%" -o "%FILE_NAME%"
) else (
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M "%URL2%" -d "%DOWNLOAD_DIR%" -o "%FILE_NAME%"
)




:: 下载ControlNet
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_ip2p_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_shuffle_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_canny_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1p_sd15_depth_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_inpaint_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_lineart_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_mlsd_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_normalbae_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_openpose_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_scribble_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_seg_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_softedge_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15s2_lineart_anime_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1e_sd15_tile_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_style_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_style_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_seg_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_seg_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_openpose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_openpose_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_keypose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_keypose_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_color_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_color_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd15v2.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd15v2.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd15v2.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_zoedepth_sd15v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_zoedepth_sd15v1.pth

:: 时间统计结束
timeout /t 3 >nul

for /f "tokens=1-3 delims=:.," %%a in ("%time%") do (
    set /a "end_time=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100"
)

set /a "duration=(end_time - start_time) / 100"

echo Stable Diffusion Webui 已安装完成，总共耗时: %duration% 秒

echo.
echo 按下任意键回车关闭窗口...
pause >nul
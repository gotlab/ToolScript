@echo off

echo.
echo 更新源代码中...
echo.

:: 更新插件代码
echo 正在更新./extensions目录及其所有子目录下的Git源码...
echo.

set "base_dir=./extensions/"
for /r "%base_dir%" %%G in (.git) do (
  pushd "%%~dpG" >nul
  if exist ".git" (
    @echo 更新 %%~dpG
    git pull
  )
  popd >nul
)

:: 更新主代码(默认未启用，有需要则删除下一句开头的'rem')
rem git pull

echo.
echo 所有Git源码更新完成。
echo.

:: 设置参数变量
rem 启用共享模式
set share=--share

rem 使用 xformers
set xformers=--xformers

rem 启用不安全的扩展访问
set enable_insecure_extension_access=--enable-insecure-extension-access

rem 使用 Gradio 队列模式
set gradio_queue=--gradio-queue

rem 启用 Cloudflare
set cloudflared=--cloudflared

rem 使用 Gradio 身份验证，用户名为 "sd"，密码为 "sdlocalpwd233"
set gradio_auth=--gradio-auth sd:sdlocalpwd233

rem 设置端口号为 7860
set port=--port 7860

rem 重新安装 Torch
set torch=--reinstall-torch

rem 重新安装 Xformers
set xformers2=--reinstall-xformers


echo 正在启动webui...
echo.

call webui.bat %share% %xformers% %enable_insecure_extension_access% %gradio_queue% %cloudflared% %gradio_auth% %port% %torch% %xformers2%


@echo off

echo.
echo ����Դ������...
echo.

:: ���²������
echo ���ڸ���./extensionsĿ¼����������Ŀ¼�µ�GitԴ��...
echo.

set "base_dir=./extensions/"
for /r "%base_dir%" %%G in (.git) do (
  pushd "%%~dpG" >nul
  if exist ".git" (
    @echo ���� %%~dpG
    git pull
  )
  popd >nul
)

:: ����������(Ĭ��δ���ã�����Ҫ��ɾ����һ�俪ͷ��'rem')
rem git pull

echo.
echo ����GitԴ�������ɡ�
echo.

:: ���ò�������
rem ���ù���ģʽ
set share=--share

rem ʹ�� xformers
set xformers=--xformers

rem ���ò���ȫ����չ����
set enable_insecure_extension_access=--enable-insecure-extension-access

rem ʹ�� Gradio ����ģʽ
set gradio_queue=--gradio-queue

rem ���� Cloudflare
set cloudflared=--cloudflared

rem ʹ�� Gradio �����֤���û���Ϊ "sd"������Ϊ "sdlocalpwd233"
set gradio_auth=--gradio-auth sd:sdlocalpwd233

rem ���ö˿ں�Ϊ 7860
set port=--port 7860

rem ���°�װ Torch
set torch=--reinstall-torch

rem ���°�װ Xformers
set xformers2=--reinstall-xformers


echo ��������webui...
echo.

call webui.bat %share% %xformers% %enable_insecure_extension_access% %gradio_queue% %cloudflared% %gradio_auth% %port% %torch% %xformers2%


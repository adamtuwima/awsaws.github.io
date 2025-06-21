
# === Установка и запуск mitmproxy с автоконфигурацией ===
$ErrorActionPreference = "Stop"

Write-Host "`n[1/5] Проверка установки pip..." -ForegroundColor Cyan
if (-not (Get-Command pip -ErrorAction SilentlyContinue)) {
    Write-Host "pip не найден. Устанавливаю..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri https://bootstrap.pypa.io/get-pip.py -OutFile "get-pip.py"
    python get-pip.py
    Remove-Item "get-pip.py"
}

Write-Host "[2/5] Установка mitmproxy..." -ForegroundColor Cyan
pip install mitmproxy --quiet

Write-Host "[3/5] Генерация сертификатов mitmproxy..." -ForegroundColor Cyan
Start-Process -NoNewWindow -Wait -FilePath "mitmproxy" -ArgumentList "--quit"

Write-Host "[4/5] Установка сертификата в доверенные..." -ForegroundColor Cyan
$certPath = "$env:USERPROFILE\.mitmproxy\mitmproxy-ca-cert.pem"
$certStore = "Root"
certutil -addstore $certStore $certPath | Out-Null

Write-Host "[5/5] Запуск mitmproxy с live_script.py..." -ForegroundColor Cyan
Start-Process -NoNewWindow -FilePath "mitmproxy" -ArgumentList "-s live_script.py"

Write-Host "`n✅ Готово. mitmproxy работает." -ForegroundColor Green

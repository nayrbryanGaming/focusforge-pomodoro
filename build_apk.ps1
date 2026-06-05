param(
    [switch]$Help
)

if ($Help) {
    Write-Host "Usage: .\build_apk.ps1"
    Write-Host "This script safely stops background processes and compiles the Android APK."
    exit
}

Write-Host "=================================================="
Write-Host "  FOCUSFORGE POMODORO - PRODUCTION BUILD SCRIPT"
Write-Host "=================================================="
Write-Host "WARNING: This requires at least 2GB of free RAM."
Write-Host "Please close Google Chrome, VSCode, and other heavy apps before continuing."
Write-Host ""
pause

Write-Host "`n[1/3] Terminating background processes to free RAM..."
taskkill /F /IM java.exe 2>$null
taskkill /F /IM dart.exe 2>$null
taskkill /F /IM node.exe 2>$null

Write-Host "`n[2/3] Cleaning Flutter project..."
cd "E:\GOOGLE PLAYSTORE PROJECT\FOCUSFORGE POMODORO\app"
flutter clean

Write-Host "`n[3/3] Compiling Release APK for ARM64..."
$env:DART_VM_OPTIONS="--old_gen_heap_size=256"
$env:JAVA_OPTS="-Xmx1024m"
$env:GRADLE_OPTS="-Xmx1024m"
flutter build apk --release --target-platform android-arm64

if (Test-Path "build\app\outputs\flutter-apk\app-release.apk") {
    Write-Host "`n[SUCCESS] APK generated successfully!"
    Write-Host "Copying to E:\Download\FocusForge.apk..."
    copy "build\app\outputs\flutter-apk\app-release.apk" "E:\Download\FocusForge.apk"
    Write-Host "DONE. You can now submit the APK."
} else {
    Write-Host "`n[ERROR] Build failed. Please close more applications to free up RAM and try again."
}
pause

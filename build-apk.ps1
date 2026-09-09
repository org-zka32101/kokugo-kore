# 国語コレ！ v1.4 APK ビルドスクリプト
# Windows PowerShell で実行してください

param(
    [string]$KeystorePassword = "",
    [string]$KeyPassword = "",
    [string]$JavaHome = "C:/Program Files/Android/Android Studio/jbr"
)

Write-Host "🚀 国語コレ！ v1.4 APK ビルド開始" -ForegroundColor Green
Write-Host ""

# パスワード入力確認
if (-not $KeystorePassword) {
    $KeystorePassword = Read-Host "KEYSTORE_PASSWORD を入力してください"
}

if (-not $KeyPassword) {
    $KeyPassword = Read-Host "KEY_PASSWORD を入力してください"
}

# 仮想ドライブ割り当て
Write-Host "📁 K: ドライブを割り当て中..." -ForegroundColor Cyan
subst K: "H:\マイドライブ\apps\kokugo-kore"

# JAVA_HOME 確認
Write-Host "☕ JAVA_HOME を確認中: $JavaHome" -ForegroundColor Cyan

# ビルド前の準備
Write-Host "📦 ビルド前の準備..." -ForegroundColor Cyan
cd K:/

# flutter pub get
Write-Host "📚 依存関係をダウンロード中..." -ForegroundColor Cyan
& flutter pub get

# APK ビルド実行
Write-Host "🔨 APK ビルド実行中..." -ForegroundColor Cyan
$env:JAVA_HOME = $JavaHome
$env:PATH = "$JavaHome\bin;$env:PATH"
$env:KEYSTORE_PASSWORD = $KeystorePassword
$env:KEY_PASSWORD = $KeyPassword

& flutter build apk --release --no-pub

Write-Host "✅ APK ビルド完了" -ForegroundColor Green

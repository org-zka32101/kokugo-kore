# 国語コレ！ v1.4 APK ビルド手順

## 🚀 概要

v1.4 フェーズが完了しました。以下の手順で APK をビルドできます。

## ✨ v1.4 で追加された機能

- ✅ Firebase Realtime Database 統合
- ✅ ランキング機能（Firebase からの実データ取得）
- ✅ ランキング表示プライバシー保護
  - デフォルト: ユーザー名を匿名化
  - ユーザー許可で本名を表示
- ✅ Google Play 定期購入 ID 更新
- ✅ Firebase セキュリティルール設定

## 📋 ビルド前チェックリスト

```
☐ Windows 環境で PowerShell を起動
☐ Flutter SDK がインストール済み
☐ Android SDK がインストール済み
☐ Java/JDK がインストール済み
☐ Keystore ファイル (release_new.jks) が存在
☐ KEYSTORE_PASSWORD を確認
☐ KEY_PASSWORD を確認
```

## 🔨 APK ビルド実行方法

### 方法 1: スクリプトを使用（推奨）

Windows PowerShell で以下を実行：

```powershell
# スクリプト実行
.\build-apk.ps1

# パスワードを指定する場合
.\build-apk.ps1 -KeystorePassword "your-keystore-password" -KeyPassword "your-key-password"
```

### 方法 2: 手動実行

```powershell
# 1. K: ドライブを割り当て
subst K: "H:\マイドライブ\apps\kokugo-kore"

# 2. K: ドライブへ移動
cd K:/

# 3. ビルド実行
$env:JAVA_HOME = "C:/Program Files/Android/Android Studio/jbr"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
$env:KEYSTORE_PASSWORD = "your-keystore-password"
$env:KEY_PASSWORD = "your-key-password"

flutter build apk --release --no-pub
```

## 📁 ビルド出力

### ビルド成果物

```
K:\build\app\outputs\flutter-apk\app-release.apk
```

### 自動コピー先

PostToolUse フックにより自動的にコピーされます：

```
H:\マイドライブ\apps\kokugo-kore\apk\app-release.apk
```

## 🔍 ビルド後の確認

```powershell
# APK ファイルサイズ確認
(Get-Item "K:\build\app\outputs\flutter-apk\app-release.apk").Length / 1MB

# APK ファイル署名確認
jarsigner -verify -verbose "K:\build\app\outputs\flutter-apk\app-release.apk"
```

## ⚠️ トラブルシューティング

### K: ドライブ割り当てエラー

```powershell
# 既に割り当てられている場合は削除
subst K: /d

# 再度割り当て
subst K: "H:\マイドライブ\apps\kokugo-kore"
```

### JAVA_HOME エラー

```powershell
# JAVA_HOME を確認
$env:JAVA_HOME
echo $env:PATH

# 正しいパスに設定
$env:JAVA_HOME = "C:/Program Files/Android/Android Studio/jbr"
```

### Flutter コマンドエラー

```powershell
# Flutter キャッシュをクリア
flutter clean

# 依存関係を再ダウンロード
flutter pub get

# Gradle キャッシュをクリア
cd K:/
./gradlew clean
```

### メモリ不足エラー

```
java.lang.OutOfMemoryError
```

の場合、GRADLE_OPTS で メモリを増やします：

```powershell
$env:GRADLE_OPTS = "-Xmx4096m"
flutter build apk --release --no-pub
```

## 📊 ビルド情報

- **Flutter Version**: >= 3.10.0
- **Android SDK Version**: API 31+
- **Gradle**: 7.0+
- **APK サイズ**: 約 50-100 MB（推定）
- **ビルド時間**: 3-10 分（マシンのスペックに依存）

## 🔐 署名情報

APK は以下の署名情報で署名されます：

- **Keystore File**: `android/app/release_new.jks`
- **Key Alias**: `kokugo_release`
- **Store Password**: `$KEYSTORE_PASSWORD`
- **Key Password**: `$KEY_PASSWORD`

## ✅ リリース前チェック

```
☐ APK ファイルが正常に生成された
☐ APK ファイル署名が有効
☐ ビルド警告がないか確認
☐ APK をテスト端末でインストールして動作確認
  - ランキング機能が動作
  - プライバシーダイアログが表示
  - 定期購入が利用可能
```

## 📝 ビルドログの保存

ビルドログを保存する場合：

```powershell
flutter build apk --release --no-pub > build-log-v1.4.txt 2>&1
```

## 🚀 次のステップ

APK ビルド後：

1. Google Play Console にアップロード
2. テストトラック (Open Testing / Closed Testing) で検証
3. 本番リリーストラックへ昇格

---

**サポート**: ビルド時に問題が発生した場合は、ビルドログを確認してください。

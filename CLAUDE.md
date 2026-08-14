# 国語コレ！ — Claude Code 開発メモ

## APKビルド手順

プロジェクトパスに日本語が含まれるため、以下の手順で回避する。

### 1. K: ドライブを割り当て（毎セッション初回のみ）

```powershell
subst K: "H:\マイドライブ\apps\kokugo-kore"
```

### 2. ビルド実行（K: ドライブから）

リリース署名用のパスワードはリポジトリに含めず環境変数で渡す（`android/app/build.gradle.kts` 参照）。`KEYSTORE_PASSWORD` / `KEY_PASSWORD` は初回に設定しておけばセッション中は保持される。

```bash
cd K:/ && JAVA_HOME="C:/Program Files/Android/Android Studio/jbr" PATH="$JAVA_HOME/bin:$PATH" KEYSTORE_PASSWORD="<release_new.jksのストアパスワード>" KEY_PASSWORD="<kokugo_releaseのキーパスワード>" flutter build apk --release --no-pub
```

### 3. APKの出力先

- ビルド成果物: `K:\build\app\outputs\flutter-apk\app-release.apk`
- 自動コピー先: `H:\マイドライブ\apps\kokugo-kore\apk\app-release.apk`

> **注意:** `flutter build apk` を含む Bash コマンドが成功すると、PostToolUse フックが自動的に `apk/` フォルダへコピーする。

## Webビルド（検証用）

パス問題なしで使用可能:

```bash
flutter build web
```

## 日本語パス問題の背景

- `H:\マイドライブ\` の日本語文字が Kotlin コンパイラ・CMake の JSON 生成時に壊れる
- `subst K:` による仮想ドライブ割り当てで回避
- `android/gradle.properties` に `android.overridePathCheck=true` 追加済み
- `android/settings.gradle.kts` でビルドディレクトリを `C:/kokugo-build/` に変更済み

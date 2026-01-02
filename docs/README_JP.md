# AndroidでOpen Interpreterを使う

[Termux](https://termux.dev/en/)を使用してAndroidデバイスでOpen Interpreterを実行します。Termuxは、root化や特別な設定なしで直接使える強力なAndroid用ターミナルエミュレータおよびLinux環境です。Samsung Galaxy Fold 6などの高性能デバイスに最適です!

<div align="center">

 | [日本語](README_JP.md) | [English](../README.md) |

</div>

---

## 🚀 クイックスタート（自動インストール)

**新機能!** すべてを自動的に処理するセットアップスクリプトを用意しました:

```bash
# セットアップスクリプトをダウンロードして実行
curl -sL https://raw.githubusercontent.com/THEFIG06/open-interpreter-termux/main/setup.sh | bash
```

またはこのリポジトリをクローンして実行:

```bash
git clone https://github.com/THEFIG06/open-interpreter-termux.git
cd open-interpreter-termux
chmod +x setup.sh
./setup.sh
```

自動スクリプトは以下を実行します:
- ✅ すべてのパッケージを更新
- ✅ 必要な依存関係をインストール
- ✅ ストレージ権限を設定
- ✅ Open Interpreterをインストール
- ✅ ヘルパースクリプトを作成
- ✅ デバイスに最適な設定を構成

**インストール後、実行:**
```bash
./setup-api-key.sh  # APIキーを設定
interpreter         # Open Interpreterを起動
```

---

## 📋 手動インストール

手動インストールを希望する場合、またはより詳細な制御が必要な場合:

### 前提条件

1. **Termuxをインストール**
   - [GitHubリリース](https://github.com/termux/termux-app/releases)からダウンロード (v0.118.1以降)
   - ⚠️ Play Storeバージョンは使用しないでください - 古いです

2. **Termux:APIをインストール** (オプションですが推奨)
   - [GitHubリリース](https://github.com/termux/termux-api/releases)からダウンロード (v0.50.1以降)
   - 追加のAndroid統合機能を有効にします

### インストール手順

Termuxを開いて以下のコマンドを実行:

#### 1. システムパッケージを更新
```bash
yes | pkg update && yes | pkg upgrade
```

#### 2. 必要なパッケージをインストール
```bash
yes | pkg install termux-api python python-pip cmake ninja patchelf build-essential matplotlib rust binutils libzmq git wget curl nano
```

**ハイエンドデバイス(8GB以上のRAM)の場合** - 追加パッケージをインストール:
```bash
yes | pkg install numpy pandas scipy
```

#### 3. ストレージ権限を設定
```bash
termux-setup-storage
```
⚠️ プロンプトが表示されたら権限を付与してください。失敗した場合は、コマンドを再度実行してください。

#### 4. pipをアップグレード
```bash
pip install --upgrade pip
```

#### 5. Open Interpreterをインストール

**標準インストール:**
```bash
pip install open-interpreter
```

**高性能デバイス(12GB以上のRAM)の場合:**
```bash
pip install "open-interpreter[local,os,safe]"
```

#### 6. APIキーを設定

AIプロバイダーを選択:

**オプションA: OpenAI (GPT-4, GPT-3.5)**
```bash
export OPENAI_API_KEY='your-openai-api-key-here'
echo "export OPENAI_API_KEY='your-openai-api-key-here'" >> ~/.bashrc
```

**オプションB: Anthropic (Claude)**
```bash
export ANTHROPIC_API_KEY='your-anthropic-api-key-here'
echo "export ANTHROPIC_API_KEY='your-anthropic-api-key-here'" >> ~/.bashrc
```

**オプションC: ローカルモデル (APIキー不要)**
```bash
# ローカルモデル用にOllamaをインストール
pkg install ollama
# 次に使用: interpreter --model ollama/llama2
```

#### 7. Open Interpreterを起動
```bash
interpreter
```

---

## 🎯 ハイエンドデバイス向けの最適化

### Samsung Galaxy Fold 6 / フラッグシップデバイス (8GB以上のRAM)

あなたのデバイスは高度な機能を処理できます! 最適化方法:

#### 1. プレミアムモデルを使用
```bash
# GPT-4o (最良の結果を得るために推奨)
interpreter --model gpt-4o

# Claude 3.5 Sonnet (コーディングに優れている)
interpreter --model claude-3-5-sonnet-20241022

# GPT-4 Turbo
interpreter --model gpt-4-turbo
```

#### 2. コンテキストウィンドウを増やす
設定ファイルを編集:
```bash
nano ~/.config/open-interpreter/config.yaml
```

追加/変更:
```yaml
model: "gpt-4o"
context_window: 8192  # 12GB以上のRAMの場合はより高く
max_tokens: 4000
temperature: 0.7
```

#### 3. 自動実行を有効化 (上級ユーザー向け)
```yaml
auto_run: true  # コードを自動実行 (注意して使用!)
safe_mode: "ask"  # オプション: "off", "ask", "auto"
```

#### 4. ML/データサイエンスライブラリをインストール
```bash
pip install numpy pandas matplotlib scikit-learn scipy jupyter
```

---

## 🔧 システム要件チェッカー

セットアップを確認するためのシステムチェッカーが含まれています:

```bash
chmod +x check-system.sh
./check-system.sh
```

これにより:
- デバイスの仕様を確認
- 必要なパッケージをすべて検証
- 最適な設定を推奨
- ハードウェアに基づく改善を提案

---

## 🖥️ UserLandでの使用

[UserLand](https://github.com/CypherpunkArmory/UserLand)は、Android上でLinuxを実行するもう一つの選択肢です。UserLandでOpen Interpreterを使用する方法:

### UserLandでのセットアップ

1. **UserLandをインストール** Play StoreまたはF-Droidから
2. **Ubuntuセッションを作成** (推奨) またはDebian
3. **システムを更新:**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

4. **Pythonと依存関係をインストール:**
   ```bash
   sudo apt install -y python3 python3-pip git build-essential cmake
   pip3 install --upgrade pip
   pip3 install open-interpreter
   ```

5. **APIキーを設定して実行:**
   ```bash
   export OPENAI_API_KEY='your-key'
   interpreter
   ```

### Termux vs UserLand

| 機能 | Termux | UserLand |
|------|--------|----------|
| パフォーマンス | ⚡ 高速 | 遅い (エミュレーション) |
| セットアップ | 簡単 | 中程度 |
| Linuxディストロ | カスタム | 完全なUbuntu/Debian |
| ストレージアクセス | 直接 | 制限あり |
| バッテリー消費 | 良好 | 高い |
| **推奨** | **推奨** | 代替 |

**Galaxy Fold 6で最高のパフォーマンスを得るには、Termuxを使用してください。**

---

## 🎨 利用可能なモデルとプロバイダー

### クラウドモデル (APIキーが必要)

**OpenAI:**
- `gpt-4o` - 最新、最も高性能 (8GB以上のRAMに推奨)
- `gpt-4-turbo` - 高速で強力
- `gpt-3.5-turbo` - 高速で経済的

**Anthropic:**
- `claude-3-5-sonnet-20241022` - コーディングに優れている
- `claude-3-opus` - 最も高性能
- `claude-3-sonnet` - バランスが良い

**その他:**
- `groq/mixtral-8x7b-32768` - Groq経由での高速推論
- `together/llama-3-70b` - Together.ai経由

### ローカルモデル (APIキー不要)

Ollamaをインストールしてローカルでモデルを実行:
```bash
pkg install ollama
ollama pull llama2
interpreter --model ollama/llama2
```

人気のローカルモデル:
- `ollama/llama2` - 汎用
- `ollama/codellama` - コード特化
- `ollama/mistral` - 効率的で高性能

---

## 📱 Termux設定

### 外部アプリを有効化

外部アプリの統合を許可するためにTermuxプロパティを編集:

```bash
nano ~/.termux/termux.properties
```

追加またはコメント解除:
```properties
allow-external-apps = true

# オプション: ターミナル使用を容易にするための追加キー
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
```

設定を再読み込み:
```bash
termux-reload-settings
```

### Open Interpreterを設定

設定ファイルの場所:
```
~/.config/open-interpreter/config.yaml
```

`~/Downloads/config.yaml`では**ありません** (Android/Termuxの制限)

編集:
```bash
nano ~/.config/open-interpreter/config.yaml
```

または対話型設定を使用:
```bash
interpreter --config
```

---

## 💡 使用上のヒントとコツ

### 基本的なコマンド

```bash
# 特定のモデルで起動
interpreter --model gpt-4o

# ローカルモード使用 (ローカルモデルでオフライン)
interpreter --local

# セーフモードで起動
interpreter --safe_mode ask

# カスタム温度を設定
interpreter --temperature 0.7

# 設定エディタを開く
interpreter --config

# バージョンを確認
interpreter --version
```

### Termuxのキーボードショートカット

- `Ctrl + C` - 現在のプロセスを停止 (チャットを終了するには2回押す)
- `Ctrl + D` - Open Interpreterを終了
- `音量アップ + Q` - 追加キーを表示
- `音量アップ + K` - キーボードを切り替え
- `音量アップ + V` - 貼り付け

### Open Interpreterの終了

**方法1:** `Ctrl + C`を2回押す
**方法2:** `exit`または`quit`を入力
**方法3:** `Ctrl + D`を押す

---

## 🚨 トラブルシューティング

一般的な問題については、[トラブルシューティングガイド](TROUBLESHOOTING.md)を参照してください。

### よくある問題

#### "Command not found: interpreter"
```bash
# 解決策: Python binをPATHに追加
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### パフォーマンスが遅い
```bash
# 解決策:
# 1. より高速なモデルを使用
interpreter --model gpt-3.5-turbo

# 2. コンテキストウィンドウを削減
# ~/.config/open-interpreter/config.yamlを編集
# context_window: 2048に設定
```

#### APIキーが認識されない
```bash
# 解決策: 設定を確認
echo $OPENAI_API_KEY

# 空の場合、設定:
export OPENAI_API_KEY='your-key'
echo "export OPENAI_API_KEY='your-key'" >> ~/.bashrc
source ~/.bashrc
```

---

## 📊 パフォーマンスベンチマーク

### Samsung Galaxy Fold 6 (12GB RAM)

| タスク | パフォーマンス | 備考 |
|--------|---------------|------|
| GPT-4o | ⭐⭐⭐⭐⭐ | 優秀、推奨 |
| Claude 3.5 | ⭐⭐⭐⭐⭐ | コードに優秀 |
| GPT-3.5 | ⭐⭐⭐⭐⭐ | 非常に高速 |
| ローカルモデル | ⭐⭐⭐⭐ | 良好、設定が必要 |
| 大規模コンテキスト(8K以上) | ⭐⭐⭐⭐⭐ | 問題なく処理 |

---

## 🔒 セキュリティとプライバシー

### ベストプラクティス

1. **APIキーを保護**
   ```bash
   # ~/.bashrcやconfig.yamlを共有しない
   # ハードコーディングではなく環境変数を使用
   ```

2. **セーフモードを使用**
   ```bash
   interpreter --safe_mode ask  # 実行前にコードをレビュー
   ```

3. **機密作業にはローカルモデルを使用**
   ```bash
   # プライベート/機密コードにはローカルモデルを使用
   interpreter --model ollama/llama2
   ```

---

## 🆕 このガイドの新機能

- ✅ 簡単インストール用の自動セットアップスクリプト
- ✅ システム要件チェッカー
- ✅ ハイエンドデバイス向けの最適化 (Galaxy Fold 6など)
- ✅ UserLand統合ガイド
- ✅ 複数のAIプロバイダーサポート (OpenAI、Anthropic、ローカルモデル)
- ✅ パフォーマンスベンチマーク
- ✅ 包括的なトラブルシューティング
- ✅ APIキー設定用ヘルパースクリプト
- ✅ 高度な設定オプション
- ✅ セキュリティベストプラクティス

---

## 🎬 使用例

AndroidでのOpen Interpreterの例については、以下の投稿をご覧ください:

- [基本的な使用例](https://x.com/MikeBirdTech/status/1707108619529916820)
- [高度な機能](https://x.com/MikeBirdTech/status/1711798317288419382)

### できること

- 📝 Pythonスクリプトの作成と実行
- 📊 pandas/numpyでのデータ分析
- 🎨 matplotlibでのプロット生成
- 🌐 Webスクレイピングとやり取り
- 📱 Termux-API経由のAndroid自動化
- 🔧 システム管理タスク
- 💻 コードデバッグとテスト
- 📚 インタラクティブなプログラミング学習

---

## 🤝 コントリビューション

問題を見つけた、またはこのガイドを改善したいですか? コントリビューションを歓迎します!

1. リポジトリをフォーク
2. 機能ブランチを作成
3. 変更をコミット
4. ブランチにプッシュ
5. プルリクエストを開く

---

## 📄 ライセンス

このプロジェクトはMITライセンスの下でライセンスされています - 詳細は[LICENSE](../LICENSE)ファイルを参照してください。

---

## 🔗 便利なリンク

- [Open Interpreter公式ドキュメント](https://docs.openinterpreter.com/)
- [Termux Wiki](https://wiki.termux.com/)
- [Termux GitHub](https://github.com/termux/termux-app)
- [UserLand GitHub](https://github.com/CypherpunkArmory/UserLand)
- [Open Interpreter GitHub](https://github.com/KillianLucas/open-interpreter)

---

## ⚡ クイックリファレンス

```bash
# インストール
./setup.sh

# システムチェック
./check-system.sh

# APIキーセットアップ
./setup-api-key.sh

# Open Interpreterを起動
interpreter

# ヘルパーで起動
./oi-start.sh

# Open Interpreterを更新
pip install --upgrade open-interpreter

# 設定の場所
~/.config/open-interpreter/config.yaml
```

---

Androidパワーユーザーのために ❤️ で作成

**Samsung Galaxy Fold 6およびその他のフラッグシップAndroidデバイスに最適!**

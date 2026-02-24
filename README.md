# vimable

dotfiles (nvim, tmux, zsh) のバックアップ・復元・自動セットアップツール。
すべての操作は Make コマンドで実行する。

## 前提条件

`make initialize` を実行する前に、以下を手動でインストールしておく必要がある。

| ツール | 必要な理由 | インストール方法 |
| --- | --- | --- |
| Node.js (npm) | coc.nvim の動作に必須。cz-git プラグインにも必要 | `brew install node` |
| Go | coc-go (gopls) が使用する Go Language Server に必要 | `brew install go` |
| terraform-ls | coc-settings.json で Terraform LSP として設定 | `brew install hashicorp/tap/terraform-ls` |

> **Note:** Go と terraform-ls はそれぞれの言語を使わない場合は不要。Node.js は coc.nvim が依存するため必須。

## Make コマンド一覧

| コマンド | 説明 |
| --- | --- |
| `make backup` | 現在の nvim/tmux/zsh 設定をタイムスタンプ付きでバックアップ |
| `make list` | バックアップ一覧を表示 |
| `make apply` | 最新のバックアップを復元（`BACKUP=<名前>` で指定可） |
| `make seed-apply` | seed/ のデフォルト設定を配置 |
| `make initialize` | 新しいマシンへの全自動セットアップ |
| `make add-plug PLUG=<name>` | 拡張ツールをインストール |

## 拡張ツール（add-plug）

`make add-plug` は `seed/plug/` に定義された拡張ツールをインストールするコマンド。

```bash
# 拡張ツールをインストール
make add-plug PLUG=cz-git

# 引数なしで利用可能な拡張一覧を表示
make add-plug
```

- 各拡張は `seed/plug/<name>/` にテンプレート設定を持つ
- 既にインストール済みの場合はスキップ（冪等）
- 前提ツールが不足している場合はエラーメッセージで案内

## 拡張機能一覧

| 名前 | 説明 | 詳細 |
| --- | --- | --- |
| cz-git | Conventional Commits 対話プロンプト（commitizen アダプター） | [README](seed/plug/cz-git/) |
| claude-map | Claude Code プロセスの実行状態を tmux ステータスバーに表示 | [README](seed/plug/claude-map/) |

## initialize の流れ

1. Homebrew インストール
2. Brewfile のパッケージインストール
3. vim-plug インストール
4. TPM（Tmux Plugin Manager）インストール
5. seed 設定配置（seed-apply）
6. プラグインインストール（vim-plug, tpope native pack, TPM）

## ディレクトリ構成

```text
seed/
  brew/Brewfile          # Homebrew パッケージ定義
  nvim/init.vim          # Neovim 設定
  nvim/coc-settings.json # CoC LSP 設定
  tmux/.tmux.conf        # tmux 設定
  zsh/.zshrc             # zsh 設定（マーカー付き追記）
  plug/cz-git/           # cz-git 拡張テンプレート
  plug/claude-map/       # claude-map 拡張テンプレート
backup/                  # タイムスタンプ付きバックアップ（gitignore）
```

## 主な特徴

- `seed/` にデフォルト設定をバージョン管理、`backup/` はユーザー固有で git 除外
- zsh は既存 `.zshrc` を壊さず `# === vimable BEGIN/END ===` マーカーで追記・差し替え
- `seed-apply` 前に既存設定を自動バックアップ（pre-seed）
- 全ステップが冪等（何度実行しても安全）

## Brewfile のパッケージ

| パッケージ | 説明 |
| --- | --- |
| neovim | テキストエディタ（Vim の後継） |
| tmux | ターミナルマルチプレクサ（セッション管理・画面分割） |
| git | バージョン管理（プラグインマネージャが使用） |
| fzf | ファジーファインダー（fzf.vim プラグインが使用） |
| ripgrep | 高速 grep（fzf.vim のバックエンド） |
| lazygit | Git TUI クライアント（lazygit.nvim から呼び出し） |

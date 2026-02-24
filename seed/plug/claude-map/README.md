# claude-map

[claude-map](https://github.com/NichiyaOba/claude-map) は Claude Code プロセスの実行状態を tmux ステータスバーに表示する tmux プラグイン。

## インストール

```bash
make add-plug PLUG=claude-map
```

### 前提条件

- tmux がインストール済み（`brew install tmux`）
- TPM (Tmux Plugin Manager) がインストール済み（`make initialize` で自動セットアップ）
- `~/.tmux.conf` が配置済み（`make seed-apply` で配置）

## インストールされるもの

| 対象 | 内容 |
| --- | --- |
| `~/.tmux.conf` | プラグイン宣言行を追加 |
| `~/.tmux/plugins/claude-map/` | TPM 経由でプラグインをインストール |

## ステータス表示

tmux ステータスバーに Claude Code の実行状態がリアルタイムで表示される。

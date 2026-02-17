# cz-git

[cz-git](https://cz-git.qbb.sh/) を使った Conventional Commits 対話プロンプト。
`git cz` で対話的にコミットメッセージを作成できる。

## インストール

```bash
make add-plug PLUG=cz-git
```

### 前提条件

- Node.js (npm) が必要（`brew install node`）

## インストールされるもの

| 対象 | 内容 |
| --- | --- |
| `cz-git` + `commitizen` | npm グローバルインストール |
| `~/.czrc` | cz-git をアダプターとして指定 |
| `~/commitlint.config.js` | コミットタイプ定義 + 日本語プロンプト設定 |

## 使い方

```bash
# 対話的にコミットメッセージを作成
git cz
```

## コミットタイプ

| タイプ | 説明 |
| --- | --- |
| feat | 新機能 |
| fix | バグ修正 |
| docs | ドキュメント |
| style | スタイル |
| refactor | リファクタリング |
| perf | パフォーマンス改善 |
| test | テスト |
| build | ビルド |
| ci | CI |
| chore | その他 |
| revert | リバート |

// @ts-check
const { defineConfig } = require('cz-git')

module.exports = defineConfig({
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'docs', 'style', 'refactor',
      'perf', 'test', 'build', 'ci', 'chore', 'revert',
    ]],
  },
  prompt: {
    types: [
      { value: 'feat',     name: 'feat:     ✨ 新機能', emoji: ':sparkles:' },
      { value: 'fix',      name: 'fix:      🐛 バグ修正', emoji: ':bug:' },
      { value: 'docs',     name: 'docs:     📝 ドキュメント', emoji: ':memo:' },
      { value: 'style',    name: 'style:    💄 スタイル', emoji: ':lipstick:' },
      { value: 'refactor', name: 'refactor: ♻️  リファクタリング', emoji: ':recycle:' },
      { value: 'perf',     name: 'perf:     ⚡ パフォーマンス改善', emoji: ':zap:' },
      { value: 'test',     name: 'test:     ✅ テスト', emoji: ':white_check_mark:' },
      { value: 'build',    name: 'build:    📦 ビルド', emoji: ':package:' },
      { value: 'ci',       name: 'ci:       👷 CI', emoji: ':construction_worker:' },
      { value: 'chore',    name: 'chore:    🔧 雑務', emoji: ':wrench:' },
      { value: 'revert',   name: 'revert:   ⏪ リバート', emoji: ':rewind:' },
    ],
    useEmoji: true,
    allowCustomScopes: true,
    allowEmptyScopes: true,
    allowBreakingChanges: ['feat', 'fix'],
  },
})

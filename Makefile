# vimable - dotfiles backup manager
# OS検出（sed互換性のため）
UNAME := $(shell uname -s)
ifeq ($(UNAME),Darwin)
  SED_INPLACE := sed -i ''
else
  SED_INPLACE := sed -i
endif

# バックアップ対象の設定
TMUX_CONF := $(HOME)/.tmux.conf
# ディレクトリ全体をコピー（init.vim, init.lua, lua/, after/, plugin/ 等すべて含む）
NVIM_DIR  := $(HOME)/.config/nvim
ZSHRC     := $(HOME)/.zshrc

# タイムスタンプとバックアップ先
TIMESTAMP  := $(shell date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR := backup/$(TIMESTAMP)

# vimable マーカー（zshrc 追記用）
VIMABLE_BEGIN := \# === vimable BEGIN ===
VIMABLE_END   := \# === vimable END ===

.PHONY: backup list apply initialize seed-apply

backup:
	@echo "=== vimable backup ==="
	@echo "Backup to: $(BACKUP_DIR)"
	@echo ""
	@# tmux
	@if [ -f "$(TMUX_CONF)" ]; then \
		mkdir -p $(BACKUP_DIR)/tmux && \
		cp $(TMUX_CONF) $(BACKUP_DIR)/tmux/ && \
		echo "[OK]   tmux  <- $(TMUX_CONF)"; \
	else \
		echo "[SKIP] tmux  -- $(TMUX_CONF) not found"; \
	fi
	@# nvim
	@if [ -d "$(NVIM_DIR)" ]; then \
		mkdir -p $(BACKUP_DIR)/nvim && \
		rsync -a --exclude='.git' $(NVIM_DIR)/ $(BACKUP_DIR)/nvim/ && \
		echo "[OK]   nvim  <- $(NVIM_DIR)/"; \
	else \
		echo "[SKIP] nvim  -- $(NVIM_DIR)/ not found"; \
	fi
	@# zsh
	@if [ -f "$(ZSHRC)" ]; then \
		mkdir -p $(BACKUP_DIR)/zsh && \
		cp $(ZSHRC) $(BACKUP_DIR)/zsh/ && \
		echo "[OK]   zsh   <- $(ZSHRC)"; \
	else \
		echo "[SKIP] zsh   -- $(ZSHRC) not found"; \
	fi
	@echo ""
	@echo "=== done ==="

list:
	@echo "=== Available backups ==="
	@ls -1 backup/ 2>/dev/null || echo "No backups found"

apply:
	@# バックアップの選択
	$(eval BACKUP ?= $(shell ls -1 backup/ 2>/dev/null | sort | tail -1))
	@if [ -z "$(BACKUP)" ]; then \
		echo "Error: No backups found"; exit 1; \
	fi
	@if [ ! -d "backup/$(BACKUP)" ]; then \
		echo "Error: backup/$(BACKUP) not found"; exit 1; \
	fi
	@echo "=== vimable apply ==="
	@echo "Apply from: backup/$(BACKUP)"
	@echo ""
	@# tmux
	@if [ -f "backup/$(BACKUP)/tmux/.tmux.conf" ]; then \
		cp backup/$(BACKUP)/tmux/.tmux.conf $(TMUX_CONF) && \
		echo "[OK]   tmux  -> $(TMUX_CONF)"; \
	else \
		echo "[SKIP] tmux  -- not in backup"; \
	fi
	@# nvim
	@if [ -d "backup/$(BACKUP)/nvim" ]; then \
		mkdir -p $(NVIM_DIR) && \
		cp -Rf backup/$(BACKUP)/nvim/ $(NVIM_DIR)/ && \
		echo "[OK]   nvim  -> $(NVIM_DIR)/"; \
	else \
		echo "[SKIP] nvim  -- not in backup"; \
	fi
	@# zsh
	@if [ -f "backup/$(BACKUP)/zsh/.zshrc" ]; then \
		cp backup/$(BACKUP)/zsh/.zshrc $(ZSHRC) && \
		echo "[OK]   zsh   -> $(ZSHRC)"; \
	else \
		echo "[SKIP] zsh   -- not in backup"; \
	fi
	@echo ""
	@echo "=== done ==="

# === seed 設定ファイルの配置 ===
seed-apply:
	@echo "=== vimable seed-apply ==="
	@# 既存設定のバックアップ
	@PRESEED="backup/pre-seed_$(TIMESTAMP)"; \
	if [ -f "$(TMUX_CONF)" ] || [ -d "$(NVIM_DIR)" ]; then \
		echo "Pre-seed backup: $$PRESEED"; \
		if [ -f "$(TMUX_CONF)" ]; then \
			mkdir -p "$$PRESEED/tmux" && \
			cp "$(TMUX_CONF)" "$$PRESEED/tmux/" && \
			echo "[BACKUP] tmux"; \
		fi; \
		if [ -d "$(NVIM_DIR)" ]; then \
			mkdir -p "$$PRESEED/nvim" && \
			rsync -a --exclude='.git' "$(NVIM_DIR)/" "$$PRESEED/nvim/" && \
			echo "[BACKUP] nvim"; \
		fi; \
		echo ""; \
	fi
	@# tmux: 上書き
	@if [ -f seed/tmux/.tmux.conf ]; then \
		cp seed/tmux/.tmux.conf "$(TMUX_CONF)" && \
		echo "[OK]   tmux  -> $(TMUX_CONF)"; \
	fi
	@# nvim: 上書き
	@if [ -f seed/nvim/init.vim ] || [ -f seed/nvim/coc-settings.json ]; then \
		mkdir -p "$(NVIM_DIR)"; \
		if [ -f seed/nvim/init.vim ]; then \
			cp seed/nvim/init.vim "$(NVIM_DIR)/" && \
			echo "[OK]   nvim/init.vim -> $(NVIM_DIR)/"; \
		fi; \
		if [ -f seed/nvim/plugins.vim ]; then \
			cp seed/nvim/plugins.vim "$(NVIM_DIR)/" && \
			echo "[OK]   nvim/plugins.vim -> $(NVIM_DIR)/"; \
		fi; \
		if [ -f seed/nvim/coc-settings.json ]; then \
			cp seed/nvim/coc-settings.json "$(NVIM_DIR)/" && \
			echo "[OK]   nvim/coc-settings.json -> $(NVIM_DIR)/"; \
		fi; \
		if [ -d seed/nvim/conf ]; then \
			mkdir -p "$(NVIM_DIR)/conf" && \
			cp seed/nvim/conf/*.vim "$(NVIM_DIR)/conf/" && \
			echo "[OK]   nvim/conf/ -> $(NVIM_DIR)/conf/"; \
		fi; \
	fi
	@# zsh: 既存 .zshrc にマーカー付きで追記（既存ブロックがあれば差し替え）
	@if [ -f seed/zsh/.zshrc ]; then \
		if [ -f "$(ZSHRC)" ] && grep -q '$(VIMABLE_BEGIN)' "$(ZSHRC)"; then \
			$(SED_INPLACE) '/$(VIMABLE_BEGIN)/,/$(VIMABLE_END)/d' "$(ZSHRC)" && \
			echo "[UPDATE] zsh  -- 既存 vimable ブロックを差し替え"; \
		fi; \
		{ echo ""; echo '$(VIMABLE_BEGIN)'; cat seed/zsh/.zshrc; echo '$(VIMABLE_END)'; } >> "$(ZSHRC)" && \
		echo "[OK]   zsh   -> $(ZSHRC) (追記)"; \
	fi
	@echo ""
	@echo "=== done ==="

# === 全自動セットアップ ===
initialize:
	@echo "=== vimable initialize ==="
	@echo ""
	@# Step 1: Homebrew
	@echo "--- Step 1: Homebrew ---"
	@if command -v brew >/dev/null 2>&1; then \
		echo "[SKIP] Homebrew already installed"; \
	else \
		echo "[INSTALL] Homebrew"; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@echo ""
	@# Step 2: brew bundle
	@echo "--- Step 2: Brew packages ---"
	@brew bundle --file=seed/brew/Brewfile
	@echo ""
	@# Step 3: vim-plug
	@echo "--- Step 3: vim-plug ---"
	@if [ -f "$(HOME)/.local/share/nvim/site/autoload/plug.vim" ]; then \
		echo "[SKIP] vim-plug already installed"; \
	else \
		echo "[INSTALL] vim-plug"; \
		curl -fLo "$(HOME)/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; \
	fi
	@echo ""
	@# Step 4: TPM
	@echo "--- Step 4: TPM (Tmux Plugin Manager) ---"
	@if [ -d "$(HOME)/.tmux/plugins/tpm" ]; then \
		echo "[SKIP] TPM already installed"; \
	else \
		echo "[INSTALL] TPM"; \
		git clone https://github.com/tmux-plugins/tpm "$(HOME)/.tmux/plugins/tpm"; \
	fi
	@echo ""
	@# Step 5: seed 設定配置
	@echo "--- Step 5: Seed configs ---"
	@$(MAKE) seed-apply
	@echo ""
	@# Step 6: プラグインインストール
	@echo "--- Step 6: Plugin installation ---"
	@echo "[vim-plug] Installing plugins..."
	@nvim --headless +PlugInstall +qall
	@echo ""
	@echo "[native pack] Installing tpope plugins..."
	@mkdir -p "$(HOME)/.local/share/nvim/site/pack/tpope/start"
	@for repo in vim-surround vim-commentary vim-repeat; do \
		if [ -d "$(HOME)/.local/share/nvim/site/pack/tpope/start/$$repo" ]; then \
			echo "[SKIP] $$repo already installed"; \
		else \
			git clone "https://github.com/tpope/$$repo.git" \
				"$(HOME)/.local/share/nvim/site/pack/tpope/start/$$repo" && \
			echo "[OK]   $$repo installed"; \
		fi; \
	done
	@echo ""
	@echo "[TPM] Installing tmux plugins..."
	@if [ -x "$(HOME)/.tmux/plugins/tpm/bin/install_plugins" ]; then \
		tmux start-server \; set-environment -g TMUX_PLUGIN_MANAGER_PATH "$(HOME)/.tmux/plugins/" && \
		$(HOME)/.tmux/plugins/tpm/bin/install_plugins; \
	else \
		echo "[ERROR] TPM install_plugins script not found"; exit 1; \
	fi
	@echo ""
	@echo "=== vimable initialize complete ==="
	@echo ""
	@echo "Next steps:"
	@echo "  1. source ~/.zshrc"
	@echo "  2. Open nvim and run :PlugInstall if any plugins failed"
	@echo "  3. In tmux, press prefix + I to install tmux plugins"

#!/bin/bash

# ============================================
# BUILD SCRIPTS ALIASES
# ============================================
alias build_docs="script/build_docs.sh"
alias build_snippets="script/build_snippets.sh"
alias build_core_shared="script/build_core_shared.sh"
alias build_structure="script/build_structure.sh"
alias build_rules_context="script/build_rules_context.sh"
alias build_lib_docs="script/build_lib_docs.sh"
alias rename_apk="script/rename_apk.sh"
alias generate_model_docs="script/generate_model_docs.sh"
alias full_clean="script/full_clean.sh"
alias duplicate_file="script/duplicate_file.sh"
alias script_tes="script/script_tes.sh"
alias build_fitur="script/build_fitur.sh"
alias cp_to_service="script/cp_to_service.sh"
alias path_paket="script/path_paket.sh"
alias code_paket="script/code_paket.sh"
alias gabung_example_teks="script/gabung_example_teks.sh"
alias install_rg="sudo apt-get update && sudo apt-get install -y ripgrep"

# Install SKILLS (ke .agents/skills/bawaan)
# Alias yang benar - jalankan dari root project
alias iskills="dart run skills@ get --all"
alias flutterskills="npx skills add flutter/skills --yes"

alias h='free -h'
alias k="code_paket"
alias cts="cp_to_service"
alias pp="path_paket"
alias bf="build_fitur"
alias t="script_tes && f"
alias r="flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080 --web-server-debug-protocol=sse --web-server-debug-backend-protocol=sse --web-server-debug-injected-client-protocol=sse"
# ============================================
# COMBINED COMMANDS
# ============================================
alias lr='path_paket && generate_model_docs && build_core_shared && build_structure && build_snippets && build_lib_docs && build_rules_context && build_docs info.md'
alias killdev='pkill -f "dart language-server" 2>/dev/null || true; pkill -f "type=extensionHost" 2>/dev/null || true; pkill -f dartaotruntime 2>/dev/null || true; pkill -f GradleDaemon 2>/dev/null || true; pkill -f "org.eclipse.equinox.launcher" 2>/dev/null || true; pkill -f "flutter_tools.snapshot" 2>/dev/null || true'
alias cleanall='killdev && full_clean'
alias bersih='rm -rf ~/.gradle ~/.dartServer ~/.cache && df -h'

# ============================================
# DART ALIASES
# ============================================
alias fbuild='dart run build_runner build --delete-conflicting-outputs'
alias fwatch='dart run build_runner watch --delete-conflicting-outputs'
alias f='dart format lib/'
# Dart fix hanya di folder lib
alias d='dart fix --apply lib/'


# ============================================
# FLUTTER ALIASES
# ============================================
alias fc='flutter clean && fum'
alias frm='flutter clean && flutter pub get && fbuild'
alias fa='flutter analyze'
alias frun='flutter run'

# Flutter Run Web Server
alias rr='flutter pub get && flutter run -d web-server --web-port=8080 --web-hostname=localhost --release'

# Build APK
alias flbuild='flutter build apk --release'
alias flbundle='flutter build appbundle --release'
alias flabi='flutter clean && flutter build apk --release --split-per-abi'
alias build64='flutter clean && flutter build apk --release --split-per-abi --target-platform android-arm64'
# ============================================
# PROJECT ALIASES
# ============================================
alias bukabash='cloudshell edit ~/.bash_aliases'
alias bukaalias='cloudshell edit ~/warkop/script/bash_aliases.sh'
alias simpan='source /workspaces/service/.bashaliases'
alias s='source ~/.bash_aliases'

# ============================================
# GIT ALIASES
# ============================================
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m "default"'
alias gp='gc && git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gitreset='git reset --hard origin/main'

# ============================================
# MONITORING
# ============================================
alias topmem='ps aux --sort=-%mem | head -15'
alias topcpu='ps aux --sort=-%cpu | head -15'
alias cekram='ps aux --sort=-%mem | head -10'
alias bersihram='killdev && sync && sudo sh -c "echo 3 > /proc/sys/vm/drop_caches" && free -h'
alias cekcpu='echo "=== Jumlah Core ===" && nproc && echo "=== Arsitektur & Model CPU ===" && lscpu && echo "=== Penggunaan CPU (snapshot) ===" && top -bn1 | head -5 && echo "=== Load Average ===" && uptime && echo "=== Detail per Core ===" && cat /proc/cpuinfo'

# ============================================
# CHECK LARGEST FILES & DIRS
# ============================================
alias besar='du -sh * | sort -hr'
alias filebesar='find . -type f -exec du -h {} + | sort -rh | head -20'
alias dirbesar='du -h . | sort -rh | head -20'

alias port='sudo netstat -tulpn | grep -E ":(8080|8081)"'
# ============================================
# NAVIGATION
# ============================================
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias global="cd ~/share_global_saya"
alias proj='cd $PROJECT_DIR'
alias script='cd $SCRIPT_DIR'


# SUPABASE
alias dblogin="npx supabase login"
alias dbc="npx supabase migration new"
alias dr="npx supabase db reset"
alias dbp="npx supabase db push"
alias dbpull="rm -rf supabase/migrations && npx supabase db pull"
alias dbfu="supabase functions deploy --use-api --project-ref xpljdcblxyfaacqzitez"
alias dbpushfunction="supabase functions deploy"
# SQL 
alias fsql="sqlfluff fix --dialect postgres --rules LT13,LT02,LT12 lib/"

# ============================================
# POSTGRES LANGUAGE SERVER
# ============================================
alias pls='postgres-language-server'
alias plsf='postgres-language-server format'
alias plsw='postgres-language-server format --write'
alias plsc='postgres-language-server check'
alias sqlfmt='for f in $(find lib/fitur supabase/migrations -name "*.sql" -type f); do postgres-language-server format "$f" --write; done'

alias formatmd="npx prettier --write "**/*.md""
# --- Project shortcut launcher ---
typeset -A PROJECTS

PROJECTS=(
  memo        "$HOME/Google Drive/マイドライブ/memo"
  landpriceapi "$HOME/workspace/src/LandpriceAPI"
  atomicity   "$HOME/workspace/Atomicity"
  billing     "$HOME/workspace/billing"
  configDeliver "$HOME/workspace/ConfigDeliver"
  departure   "$HOME/workspace/Departure"
  edifice     "$HOME/workspace/Edifice"
  news        "$HOME/workspace/src/news"
  tosi        "$HOME/workspace/src/tosi"
  wp-products "$HOME/workspace/src/wp-products"
  zshrc       "$HOME/.zshrc"
  ssh         "$HOME/.ssh"
  claude      "$HOME/.claude"
)

# プロジェクトパス解決（未登録ならパスとして扱う）
_resolve_project() {
  local key="$1"
  if [[ -n "${PROJECTS[$key]}" ]]; then
    echo "${PROJECTS[$key]}"
  elif [[ -e "$key" ]]; then
    echo "$key"
  else
    return 1
  fi
}

# Usage表示 + パス解決（各関数から呼ぶ）
_project_path_or_usage() {
  local app_name="$1" key="$2"

  if [[ -z "$key" ]]; then
    echo "Usage: $app_name <project>"
    echo ""
    echo "Available projects:"
    for k in ${(ko)PROJECTS}; do
      echo "  $k -> ${PROJECTS[$k]}"
    done
    return 1
  fi

  _resolve_project "$key"
  if [[ $? -ne 0 ]]; then
    echo "Unknown project: $key"
    echo ""
    echo "Available:"
    for k in ${(ko)PROJECTS}; do echo "  $k"; done
    return 1
  fi
}

# 補完（全コマンド共通）
_complete_projects() {
  compadd ${(ko)PROJECTS}
}

# c = Cursor
c() {
  local path
  path="$(_project_path_or_usage c "$1")" || { echo "$path"; return 1; }
  /usr/bin/open -a "Cursor" "$path"
}
compdef _complete_projects c

# v = VSCode
v() {
  local path
  path="$(_project_path_or_usage v "$1")" || { echo "$path"; return 1; }
  /usr/bin/open -a "Visual Studio Code" "$path"
}
compdef _complete_projects v

# z = Zed
z() {
  local path
  path="$(_project_path_or_usage z "$1")" || { echo "$path"; return 1; }
  /usr/bin/open -a "Zed" "$path"
}
compdef _complete_projects z

# g = Ghostty（新しいウィンドウで開く）
g() {
  local path
  path="$(_project_path_or_usage g "$1")" || { echo "$path"; return 1; }
  /usr/bin/open -n -a Ghostty --args --working-directory="$path"
}
compdef _complete_projects g

# f = Finder
f() {
  local path
  path="$(_project_path_or_usage f "$1")" || { echo "$path"; return 1; }
  /usr/bin/open "$path"
}
compdef _complete_projects f

# i = iTerm（新しいウィンドウで開く）
i() {
  local path
  path="$(_project_path_or_usage i "$1")" || { echo "$path"; return 1; }
  /usr/bin/open -n -a "iTerm" "$path"
}
compdef _complete_projects i

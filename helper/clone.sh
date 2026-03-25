#!/usr/bin/env bash

REPOSITORY_LINKS=(
  https://github.com/robbyrussell/oh-my-zsh
  https://github.com/zsh-users/zsh-syntax-highlighting
  https://github.com/zsh-users/zsh-autosuggestions
  https://github.com/joshskidmore/zsh-fzf-history-search
  https://github.com/marlonrichert/zsh-autocomplete
  https://github.com/jimeh/tmux-themepack
  https://github.com/NvChad/starter
)

REPOSITORY_APIS=(
  repositories/291137
  repos/zsh-users/zsh-syntax-highlighting
  repos/zsh-users/zsh-autosuggestions
  repos/joshskidmore/zsh-fzf-history-search
  repos/marlonrichert/zsh-autocomplete
  repos/jimeh/tmux-themepack
  repos/NvChad/starter
)

REPOSITORY_FULL_NAME=(
  robbyrussell/oh-my-zsh
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
  joshskidmore/zsh-fzf-history-search
  marlonrichert/zsh-autocomplete
  jimeh/tmux-themepack
  NvChad/starter
)

REPOSITORY_PATH=(
  $HOME/.oh-my-zsh/
  $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  $HOME/.oh-my-zsh/custom/plugins/zsh-fzf-history-search
  $HOME/.oh-my-zsh/custom/plugins/zsh-autocomplete
  $HOME/.tmux-themepack
  $HOME/NvChad
)

# ─── helper: คำนวณขนาด repo ด้วย awk แทน bc ──────────────────────────────────
function repoSize() {
  local raw_size
  raw_size=$(curl -s "https://api.github.com/$@" | grep '"size"' | head -1 | tr -dc '0-9')
  if [[ -n "$raw_size" && "$raw_size" -gt 0 ]]; then
    awk "BEGIN { printf \"%.2fMB\", $raw_size / 1024 }"
  else
    echo "N/A"
  fi
}
# ─────────────────────────────────────────────────────────────────────────────

function repositories() {

  setCursor off

  echo -e "‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Getting Information Repository"
  sleep 2s

  echo -e "
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                         Information Repository                     ┃ 
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃      Repository Name                          Repository Size      ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

  for REPOSITORY_API in "${REPOSITORY_APIS[@]}"; do

    REPOSITORY_NAME=$(curl -s "https://api.github.com/${REPOSITORY_API}" | grep full_name | sed -n 1p | awk '{print $2}' | sed "s/,//g" | sed "s/\"//g")
    printf  "    ┃      ${COLOR_SUCCESS}%-36s${COLOR_BASED}       ${COLOR_WARNING}%8s${COLOR_BASED}           ┃\n" $REPOSITORY_NAME "$(repoSize $REPOSITORY_API)"
    echo -e "    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

  done

  echo -e ""

}

# ─── helper: git clone พร้อม retry 3 ครั้ง ────────────────────────────────────
function cloneWithRetry() {
  local url=$1
  local dest=$2
  local max_retries=3
  local attempt=1

  while [[ $attempt -le $max_retries ]]; do
    git clone --depth=1 "$url" "$dest" 2>/dev/null && return 0
    attempt=$((attempt + 1))
    sleep 2
  done
  return 1
}
# ─────────────────────────────────────────────────────────────────────────────

function cloneRepository() {

  setCursor off

  echo -e "\n‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Clone or Downloading Repository\n"  
  sleep 2s

  for ((i=0; i<${#REPOSITORY_LINKS[@]}; i++)); do

    start_animation "       Cloning ${COLOR_WARNING}'${COLOR_SUCCESS}${REPOSITORY_FULL_NAME[i]}${COLOR_WARNING}'${COLOR_BASED} ..."

    cloneWithRetry "${REPOSITORY_LINKS[i]}" "${REPOSITORY_PATH[i]}"
    CLONE_STATUS=$?

    if [ -d "${REPOSITORY_PATH[i]}" ]; then
      stop_animation 0 || exit 1
    else
      stop_animation $CLONE_STATUS
    fi

  done

  setCursor on

}

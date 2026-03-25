#!/usr/bin/env bash

PACKAGES=(
  bat curl eza fzf git
  lf mpd mpc neovim
  neofetch termux-api tmux zsh
)

# ─── helper: แปลง kB/MB เป็น MB ด้วย awk (ไม่ต้องใช้ bc) ───────────────────
function toMB() {
  local value=$1
  local unit=$2
  if [[ "$unit" == "kB" ]]; then
    awk "BEGIN { printf \"%.1f\", $value / 1024 }"
  else
    awk "BEGIN { printf \"%.1f\", $value }"
  fi
}

function addFloat() {
  awk "BEGIN { printf \"%.1f\", $1 + $2 }"
}
# ─────────────────────────────────────────────────────────────────────────────

function packages() {

  setCursor off

  TOTAL_DOWNLOAD_MB=0
  TOTAL_INSTALLED_MB=0

  echo -e "‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Getting Information Packages"

  echo -e "
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                 Information Packages                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃      Package Name              Version             Download           Installed     ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

  for PACKAGE in "${PACKAGES[@]}"; do

    PACKAGE_NAME=$(apt show $PACKAGE 2> /dev/null | grep Package: | awk '{print $2}')
    VERSION=$(apt show $PACKAGE 2> /dev/null | grep Version: | awk '{print $2}')

    DOWNLOAD_SIZE=$(apt show $PACKAGE 2> /dev/null | grep Download-Size: | awk '{print $2}')
    INSTALLED_SIZE=$(apt show $PACKAGE 2> /dev/null | grep Installed-Size: | awk '{print $2}')

    UNIT_DOWNLOAD_SIZE=$(apt show $PACKAGE 2> /dev/null | grep Download-Size: | awk '{print $3}')
    UNIT_INSTALLED_SIZE=$(apt show $PACKAGE 2> /dev/null | grep Installed-Size: | awk '{print $3}')

    printf  "    ┃      ${COLOR_SUCCESS}%-13s${COLOR_BASED}          ${COLOR_WARNING}%10s${COLOR_BASED}              ${COLOR_WARNING}%-4s${COLOR_BASED} %-2s             ${COLOR_WARNING}%-4s${COLOR_BASED} %-2s     ┃\n" $PACKAGE_NAME $VERSION ${DOWNLOAD_SIZE} "${UNIT_DOWNLOAD_SIZE}" ${INSTALLED_SIZE} "${UNIT_INSTALLED_SIZE}"
    echo -e "    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

    # คำนวณด้วย awk แทน bc
    if [[ -n "$DOWNLOAD_SIZE" && -n "$INSTALLED_SIZE" ]]; then
      PKG_DL_MB=$(toMB "$DOWNLOAD_SIZE" "$UNIT_DOWNLOAD_SIZE")
      PKG_IN_MB=$(toMB "$INSTALLED_SIZE" "$UNIT_INSTALLED_SIZE")
      TOTAL_DOWNLOAD_MB=$(addFloat "$TOTAL_DOWNLOAD_MB" "$PKG_DL_MB")
      TOTAL_INSTALLED_MB=$(addFloat "$TOTAL_INSTALLED_MB" "$PKG_IN_MB")
    fi

  done

  printf    "    ┃     [ ${COLOR_WARNING}%5s${COLOR_BASED} ]  ─────────────────────────────────> ${COLOR_WARNING}%6s${COLOR_BASED} %-2s           ${COLOR_WARNING}%6s${COLOR_BASED} %-2s     ┃" "TOTAL" ${TOTAL_DOWNLOAD_MB} "MB" ${TOTAL_INSTALLED_MB} "MB"
  echo -e "\n    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

  echo ""

}

function installPackages() {

  setCursor off

  echo -e "\n‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Downloading Packages\n"

  for PACKAGE in "${PACKAGES[@]}"; do

    start_animation "       Installing ${COLOR_WARNING}'${COLOR_SUCCESS}${PACKAGE}${COLOR_WARNING}'${COLOR_BASED} ..."

    pkg i -y $PACKAGE &>/dev/null

    # แก้ logic ตรวจสอบ: ใช้ dpkg แทน pkg list-installed ที่ไม่ reliable
    if dpkg -l "$PACKAGE" 2>/dev/null | grep -q "^ii"; then
      stop_animation 0 || exit 1
    else
      stop_animation 1
    fi

  done

  setCursor on

}

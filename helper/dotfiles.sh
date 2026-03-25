#!/usr/bin/env bash

BACKUP_DOTFILES=(
  .autostart .aliases
  .config .colorscheme
  .fonts .local .scripts
  .termux .tmux.conf
  .zshrc .oh-my-zsh
)

DOTFILES=(
  .autostart .aliases
  .config .colorscheme
  .fonts .local .scripts
  .termux .tmux.conf
  .zshrc
)


function dotFiles() {

  setCursor off

  echo -e "\n‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Getting Information Dotfiles"
  sleep 2s

  echo -e "
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃             Information Dotfiles              ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃        Folder Name            Folder Size     ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

  for DOTFILE in "${DOTFILES[@]}"; do

    FOLDER_SIZE=$(du -s -h $DOTFILE | awk '{print $1}')
    printf  "    ┃        ${COLOR_SUCCESS}%-12s${COLOR_BASED}              ${COLOR_WARNING}%5s${COLOR_BASED}        ┃\n" $DOTFILE $FOLDER_SIZE
    echo -e "    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

  done

  echo ""

}

function backupDotFiles() {

  echo -e "‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Backup Dotfiles"
  echo -e ""
  sleep 2s

  for BACKUP_DOTFILE in "${BACKUP_DOTFILES[@]}"; do

    start_animation "       Backup ${COLOR_WARNING}'${COLOR_SUCCESS}${BACKUP_DOTFILE}${COLOR_WARNING}'${COLOR_BASED} ..."
    sleep 1s

    if [[ -d "$HOME/$BACKUP_DOTFILE" || -f "$HOME/$BACKUP_DOTFILE" ]]; then

      # แก้: เก็บ timestamp ไว้ใน variable เดียว ใช้ร่วมกันทั้ง mv และ check
      BACKUP_TIMESTAMP=$(date +%Y.%m.%d-%H.%M.%S)
      BACKUP_DEST="${HOME}/${BACKUP_DOTFILE}.${BACKUP_TIMESTAMP}.backup"

      mv "${HOME}/${BACKUP_DOTFILE}" "${BACKUP_DEST}"

      if [[ -d "${BACKUP_DEST}" || -f "${BACKUP_DEST}" ]]; then
        stop_animation 0 || exit 1
      else
        stop_animation 1
      fi

    else

      # ไม่มีไฟล์เดิม = ไม่ต้อง backup = ถือว่า success (skip)
      stop_animation 0

    fi

  done

  echo -e ""

}

function installDotFiles() {

  setCursor off

  echo -e "\n‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Installing Dotfiles\n"

  for DOTFILE in "${DOTFILES[@]}"; do

    if [ "${DOTFILE}" == ".termux" ]; then

      start_animation "       Installing ${COLOR_WARNING}'${COLOR_SUCCESS}${DOTFILE}${COLOR_WARNING}'${COLOR_BASED} ..."
      cp -R $DOTFILE $HOME

      if [[ -d $HOME/$DOTFILE || -f $HOME/$DOTFILE ]]; then
        termux-reload-settings
        stop_animation $? || exit 1
      else
        stop_animation $?
      fi

    else

      start_animation "       Installing ${COLOR_WARNING}'${COLOR_SUCCESS}${DOTFILE}${COLOR_WARNING}'${COLOR_BASED} ..."
      cp -R $DOTFILE $HOME

      if [[ -d $HOME/$DOTFILE || -f $HOME/$DOTFILE ]]; then
        stop_animation $? || exit 1
      else
        stop_animation $?
      fi

    fi

  done

  echo -e ""

  setCursor on
  
}

#!/usr/bin/env bash

VERSION="0.6.2"
BUILD_DATE="03 April 2022"
AUTHOR="NoukEiei01"
GITHUB="github.com/NoukEiei01"
INSTAGRAM="nouk.eiei"
FACEBOOK="Nouk Eiei"
TELEGRAM="nouk_eiei"

function banner() {

  echo -e "
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                _   _                 _                        ┃
    ┃               | \ | |               | |                       ┃
    ┃               |  \| | ___  _   _  __| |__                     ┃
    ┃               | . ` |/ _ \| | | |/ /| |/ /                    ┃
    ┃               | |\  | (_) | |_| < < |   <                     ┃
    ┃               |_| \_|\___/ \__,_|\_\ |_|\_\                   ┃
    ┃                                                                ┃
    ┃                  🚀 Version    : ${VERSION}                         ┃
    ┃                  📅 Build Date : ${BUILD_DATE}                 ┃
    ┃                  ⚙️ Author     : ${AUTHOR}                          ┃
    ┃                                                                ┃
    ┃                  🐙 GitHub     : ${GITHUB}              ┃
    ┃                  📸 Instagram  : ${INSTAGRAM}                    ┃
    ┃                  📘 Facebook   : ${FACEBOOK}                     ┃
    ┃                  ✈️ Telegram   : ${TELEGRAM}                     ┃
    ┃                                                                ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  "
}

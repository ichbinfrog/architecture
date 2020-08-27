#!/bin/bash
# Logging utility

log::__msg() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')][$(whoami)]" + " $1" + ": " + "$2"
}

log::__info() {
  log::__msg "INF" "$1"
}

log::__error() {
  log::__msg "ERR" "$1"
}
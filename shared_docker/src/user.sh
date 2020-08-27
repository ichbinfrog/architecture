#!/bin/bash
# User add utility

. ./log.sh

user::__add_user() {
  # Create user if not exist
  useradd "$1" || log::__info "User " + "$1" + " already exists"

  # Add user to docker group
  sudo usermod -aG docker "$1" || :
}
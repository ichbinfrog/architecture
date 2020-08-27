#!/bin/bash
# Automatic daily host pruning

prune::__docker_author() {
  docker system prune --filter='author:'
  docker system prune --filter='org:'
}

prune::__docker_date() {
  docker system prune --filter='until:'
}

prune::__cron() {
  crontab "$1" prune::__docker_date
  crontab "$1" prune::__docker_author
}
#!/bin/bash
set -e

bundle install

if [ "$TASK_DEFINITION_NAME" = "service" ]; then
  echo "Running migrations and seeds for service"
  bundle exec rake db:migrate
  bundle exec rake db:seed
  echo "Finish running migrations and seeds for service"

  pid_file="/usr/src/app/tmp/pids/server.pid"

  # only removes the PID file if there's no running process with that ID.
  if [ -f $pid_file ]; then
      pid=$(cat $pid_file)
      if ! kill -0 $pid > /dev/null 2>&1; then
          echo "Removing stale server.pid file."
          rm -f $pid_file
      else
          echo "Server is still running with PID $pid."
      fi
  fi
fi

exec "$@"

# if you want to use debugger: docker attach $(docker-compose ps -q web) in another terminal
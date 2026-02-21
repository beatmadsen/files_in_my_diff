#!/bin/bash

port=$(run_or_locate_left_ci)



if [[ "$1" == "--fast" ]]; then
  ./fast/run.sh
  ./fast/wait.sh
else
  ./fast/run.sh
  ./slow/run.sh
  ./fast/wait.sh
fi


run_or_locate_left_ci() {
  # Random int
  echo $((RANDOM % 10000))
}

#!/usr/bin/env bash
set -o errexit
ls | grep -v runscripts | xargs rm -rf
delitec *.scala
printf "\n%s\n" "(Phase three) DSL execution..."
delite
#!/bin/bash

# Runs `bundle install` in `libraries`, `domains`, `apps`, and top level kit

cyan='\e[1;36m%s\e[0m\n'

cd -P .
for dir in ./libraries/*/
do cd -P "$dir" ||continue
   printf "\\nRunning in: $cyan%s" "$PWD" >&2
   bundle install && cd "$OLDPWD" ||
! break; done || ! cd - >&2

cd -P .
for dir in ./domains/*/
do cd -P "$dir" ||continue
   printf "\\nRunning in: $cyan%s" "$PWD" >&2
   bundle install && cd "$OLDPWD" ||
! break; done || ! cd - >&2

cd -P .
for dir in ./apps/*/
do cd -P "$dir" ||continue
   printf "\\nRunning in: $cyan%s\\n" "$PWD" >&2
   bundle install && cd "$OLDPWD" ||
! break; done || ! cd - >&2

cd -P .
printf "\\nRunning in: $cyan%s\\n" "$PWD" >&2
bundle install

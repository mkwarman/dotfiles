#!/bin/bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

path+=("/Users/mkwarman/bin")
export PATH

alias ll="ls -al"
alias tas="tmux attach-session -t"
alias tls="tmux ls"

# cd to project directories
alias devmono="cd ~/Development/mono"

alias devtribbles="cd ~/Development/mono/bytes/tribbles"
alias devsisko="cd ~/Development/mono/bytes/sisko"

alias devweyoun="cd ~/Development/mono/devops/weyoun"
alias devb4="cd ~/Development/mono/devops/b4"
alias devmccoy="cd ~/Development/mono/devops/mccoy"

alias devmorn="cd ~/Development/mono/packages/morn"
alias devcommon="cd ~/Development/mono/packages/common"
alias devfederation-sdk="cd ~/Development/mono/packages/federation-sdk"

alias devla-forge="cd ~/Development/mono/services/la-forge"
alias devchakotay="cd ~/Development/mono/services/chakotay"
alias devmira="cd ~/Development/mono/services/mira"
alias devpicard="cd ~/Development/mono/services/picard"
alias devquark="cd ~/Development/mono/services/quark"
alias devuhura="cd ~/Development/mono/services/uhura"

# Get project directories. Should probably make a variable for mono path
# find /Users/mkwarman/Development/mono/{devops,packages,services,bytes}/* -maxdepth 0 -type d

find_service () {
  echo $(command ls -d ~/Development/mono/services/* | grep "$1")
}

find_byte () {
  echo $(command ls -d ~/Development/mono/bytes/* | grep "$1")
}

find_package () {
  echo $(command ls -d ~/Development/mono/packages/* | grep "$1")
}

find_devops () {
  echo $(command ls -d ~/Development/mono/devops/* | grep "$1")
}

start () {
  if [[ -z $1 ]]; then
    echo "Name of service or byte is required"
    return 1
  fi

  for arg in "$@"; do
    found_service=$(find_service "$arg")
    if [[ -n $found_service ]]; then
      tmux_command="cd $found_service; yarn start"
      command tmux new-session -d -s "$arg" "$tmux_command"
      if [[ "$?" == 0 ]]; then
        echo "Started service $arg"
      fi
      continue
    fi

    found_byte=$(find_byte "$arg")
    if [[ -n $found_byte ]]; then
      if [[ "$arg" == "tribbles" ]]; then
        tmux_command="cd $found_byte; yarn start-tribbles"
      else
        tmux_command="cd $found_byte; yarn start-byte"
      fi
      command tmux new-session -d -s "$arg" "$tmux_command"
      if [[ "$?" == 0 ]]; then
        echo "Started byte $arg"
      fi
      continue
    fi
  done
}

codef () {
  if [[ -z "$1" ]]; then
    echo "Project name is required"
    return 1
  fi

  found_service=$(find_service "$1")
  if [[ -n $found_service ]]; then
    command code "$found_service"
    return 0;
  fi

  found_byte=$(find_byte "$1")
  if [[ -n $found_byte ]]; then
    command code "$found_byte"
    return 0;
  fi

  found_package=$(find_package "$1")
  if [[ -n $found_package ]]; then
    command code "$found_package"
    return 0;
  fi

  found_devops=$(find_devops "$1")
  if [[ -n $found_devops ]]; then
    command code "$found_devops"
    return 0;
  fi

  echo "No matching project found"
}

git() {
  if [[ $@ == "ls" || $@ == "pwd" ]]; then
    command git branch --show-current
  
  elif [[ $1 == "findbranch" || $1 == "branchf" || $1 == "fbranch" ]]; then
    matching_branches=$(command git branch -l | grep "$2")
    if [[ "$matching_branches" == "" ]]; then
      echo "No matches found"
    else
      echo "$matching_branches"
    fi

  elif [[ $1 == "findcheckout" || $1 == "checkoutf" || $1 == "fcheckout" ]]; then
    matching_branches=$(command git branch -l | grep "$2")
    num_branches_found=$(echo "$matching_branches" | wc -l)
    if [[ "$num_branches_found" -gt 1 ]]; then
      echo "Multiple matching branches found:\n$matching_branches"
    elif [[ "$matching_branches" == "" ]]; then
      echo "No matches found"
    elif [[ "$num_branches_found" -eq 1 ]]; then
      trimmed_branch=$(echo "$matching_branches" | sed 's/ //g')
      command git checkout "$trimmed_branch"
    fi

  elif [[ $@ == "mergemain" ]]; then
    current_branch=$(command git branch --show-current)
    command git checkout main;
    command git pull;
    command git checkout "$current_branch";
    command git merge main;
    command git status;

  elif [[ $@ == "autoresolve" ]]; then
    current_dir=$(command pwd);
    current_branch=$(command git branch --show-current)
    command cd "~/Development/mono/packages/morn";
    command git checkout main;
    command git pull;
    command git checkout "$current_branch";
    command git merge main;
    command yarn generate-la-forge-types;
    command yarn format;
    command yarn lint;
    command cd "$current_dir";
    command git status;
 
  else
    command git "$@"
  fi
}

buildall() {
  current_dir=$(command pwd);
  command cd ~/Development/mono;
  command yarn;
  command yarn build:all;
  command cd "$current_dir";
}

# Set the title of the current tab
nametab() {
  echo -en "\033]0;$@\007"
}

# Convert a csv to a json string. Useful for migrations
jsonify() {
  input_filename="$1"
  output_filename="${input_filename%.*}"
  if [[ $# -gt 1 ]]; then
    output_filename="$2"
  fi

  sed -e ':a' -e 'N' -e '$!ba' -e 's/\"/\\"/g; s/\r\n/\\n/g; s/\n/\\n/g' "${input_filename}" > "${output_filename}.json"
}

gitlogslack() {
  if [[ $# -gt 1 ]]; then
    to_hash="$2"
  else
    to_hash="HEAD"
  fi

  if [[ $# -gt 0 ]]; then
    range="$1..$to_hash"
  fi

  command git log origin --pretty=%s $range | perl -pe 's/.*\[skip ci\].*//g' | grep -v -e '^$' | perl -pe 's/(?:[zZ][fF]1[- _]?([0-9]+))/\[ZF1-\1]\(https:\/\/puzzl.atlassian.net\/browse\/ZF1-\1\)/g' | perl -pe 's/\#([0-9]+)/[#\1](https:\/\/github.com\/zeal-corp\/mono\/pull\/\1)/g' | perl -pe 's/^/* /g'
}


nvm use 16

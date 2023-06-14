#!/bin/bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

path+=("/Users/mkwarman/bin")
export PATH

alias ll="ls -al"

# cd to project directories
alias devmono="cd ~/Development/mono"
alias devlaforge="cd ~/Development/mono/services/la-forge"
alias devchakotay="cd ~/Development/mono/services/chakotay"
alias devmorn="cd ~/Development/mono/packages/morn"
alias devtribbles="cd ~/Development/mono/bytes/tribbles"
alias devsisko="cd ~/Development/mono/bytes/sisko"

# open VSCode to project directories
alias codemono="code ~/Development/mono"
alias codelaforge="code ~/Development/mono/services/la-forge"
alias codechakotay="code ~/Development/mono/services/chakotay"
alias codemorn="code ~/Development/mono/packages/morn"
alias codetribbles="code ~/Development/mono/bytes/tribbles"
alias codesisko="code ~/Development/mono/bytes/sisko"



find_service () {
  echo $(command ls -d ~/Development/mono/services/* | grep "$1")
}

find_byte () {
  echo $(command ls -d ~/Development/mono/bytes/* | grep "$1")
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


nvm use 16

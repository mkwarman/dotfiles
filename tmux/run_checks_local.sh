session=checks-local

tmux has-session -t $session 2>/dev/null

if [ $? != 0 ]; then
  tmux new-session -d -s $session
  tmux send-keys -t $session "nvm use 16 && cd ~/Development/mono/services/picard && yarn build && yarn start" Enter
  tmux split-window -h -t $session
  tmux send-keys -t $session "nvm use 16 && cd ~/Development/mono/services/quark && yarn build && yarn start" Enter
  tmux split-window -v -t $session
  tmux send-keys -t $session "nvm use 16 && cd ~/Development/mono/services/tasha && yarn build && yarn start" Enter
  # tmux split-pane -v -t $session -t left
  # tmux send-keys -t $session "nvm use 16 && cd ~/Development/mono/services/picard && yarn build && yarn start" Enter
fi

if [[ $@ != "-d" ]]; then
  tmux attach-session -t $session
fi

session=all-local

tmux has-session -t $session 2>/dev/null

if [ $? != 0 ]; then
  tmux new-session -d -s $session
  tmux send-keys -t $session "nvm use 16 && cd ~/Development/mono && yarn && yarn dev" Enter
fi

if [[ $@ != "-d" ]]; then
  tmux attach-session -t $session
fi

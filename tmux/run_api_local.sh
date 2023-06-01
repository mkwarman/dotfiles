session=api-local

tmux has-session -t $session 2>/dev/null

if [ $? != 0 ]; then
  tmux new-session -d -s $session
  tmux send-keys -t $session "nvm use 16 && cd ~/Development/mono/services/la-forge && yarn build && yarn start" Enter
  tmux split-window -h -t $session
  tmux send-keys -t $session "nvm use 16 && cd ~/Development/mono/services/riker && yarn build && yarn start" Enter
fi

if [[ $@ != "-d" ]]; then
  tmux attach-session -t $session
fi

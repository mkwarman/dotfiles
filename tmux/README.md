## Tmux Scripts

You must have tmux installed to use these.

These scripts can be used to start up specific groups of Zeal services in order to develop specific areas or services without having to run everything at once. I put these files in a /bin directory in my home folder and add that directory to my path in `.zprofile` so that I can run them from anywhere. 

Pass argument `-d` to start detached.

Running a script after detacting from an existing session (Ctrl-b d) will automatically reattach you to the existing session.

To quickly stop all services within a tmux session, you can:
1. Press `Ctrl-b` then `:` to enter command mode.
2. Input `setw syncronize-panes` (use tab autocomplete for easier input) and press Enter/Return key.
> At this point any input you enter will be sent to all sessions.
3. Press `Ctrl-c` and wait for services to stop.
5. Input `exit` and press the Enter/Return key.

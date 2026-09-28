# Undercurl
set -g default-terminal "${TERM}"

set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
set -as terminal-overrides ',*:Setulc=\E[58::2::::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0+
# Enable 24 bit true colors
set -ga terminal-overrides ',*:Tc'

# tips from https://www.youtube.com/watch?v=-f9rz7joEOA
# other prefix better to reach than C-b+
# set-option -g prefix2 C-f
set-option -g prefix C-b
# note: ctrl-j is equal to ctrl-enter / line-feed. this means ctrl-enter switches panes.
# fix that we bind Shift+enter to line-feed like in many browser/chat applications
# Bind Shift+Enter (S-Enter) to send a line feed (like Enter) -- workaround for Ctrl-J behavior
# bind-key -n 'M-Enter' 'select-pane -R'



# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
# comment
vim_pattern='(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?'
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +${vim_pattern}$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R

# Restoring Clear Screen (C-l)
# The default key bindings include <Ctrl-l> which is the readline key binding for clearing the screen. The following binding can be added to your ~/.tmux.conf file to provide an alternate mapping to clear-screen. but also we clear the tmux history which could still be scrolled to

# bind-key 'C-l' send-keys 'C-l' 
# seems like C-l makes problems
# bind-key 'C-l' display-message 'Screen and history cleared via Tmux.conf' \; send-keys 'clear' C-m \; clear-history 
bind-key 'C-k' display-message 'Screen and history cleared via Tmux.conf Prefix + C-k' \; send-keys 'clear && tmux clear-history'

# Restoring SIGQUIT (C-\)
#
# The default key bindings also include <Ctrl-\> which is the default method of sending SIGQUIT to a foreground process. Similar to "Clear Screen" above, a key binding can be created to replicate SIGQUIT in the prefix table.
#
#
# bind C-\\ send-keys "C-\"
# Better splitting
bind-key v split-window -h
bind-key h split-window -v

# set :q to kill the pane just like nvim
set -s command-alias[10] q='kill-pane'

# Easy config reload
bind-key r source-file ~/.tmux.conf \; display-message "tmux.conf reloaded"


# https://stackoverflow.com/questions/18600188/home-end-keys-do-not-work-in-tmux
# allows jumping to end and start of line via home and end button
# default way is <C-e> and <C-a>
bind-key -n Home send Escape "OH"
bind-key -n End send Escape "OF"

set -s set-clipboard on
set-option -g mouse on
set -as terminal-features ',xterm-256color:clipboard'
# set -s copy-command 'xsel -i'

# https://gist.github.com/pbnj/67c16c37918ba40bbb233b97f3e38456
# toggle tmux terminal with ctrl - \
# note ctrl - / does not work
bind-key -n 'C-\' if-shell '[ "$(tmux list-panes | wc -l | bc)" = 1 ]' {
 split-window -c '#{pane_current_path}'
} { if-shell '[ -n "$(tmux list-panes -F ''#F'' | grep Z)" ]' { select-pane -t:.- } { resize-pane -Z -t0 }}

# help / keys / shortcuts tmux list-keys


# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'fabioluciano/tmux-tokyo-night'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'christoomey/vim-tmux-navigator'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'github_username/plugin_name#branch'
# set -g @plugin 'git@github.com:user/plugin'
# set -g @plugin 'git@bitbucket.com:user/plugin'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

# Weaken the tab incdicator for inactive tabs
# Overrides tokyo-night theme (must be after run line)
set -g window-status-format '  #I:#W  '


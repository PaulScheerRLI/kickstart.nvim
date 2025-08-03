# 🔁 dejavu

Dejavu is a plugin to improve the repeat pattern in nvim.
The [native dot command ](https://neovim.io/doc/user/repeat.html)  supports a variety of repetitions but some are missing which make some commands awkward.
Other plugins allow registering commands to make them repeatable.

- https://github.com/jonatan-branting/nvim-better-n
- https://github.com/tpope/vim-repeat/tree/master

Both need setup for commands to make them repeatable.
Dejavu follows a different approach.
The last normal mode commands is simply made available.

## ✨ Features
Repeat the following things by creating a macro for it
- hjkl commands with a count
- f/F search
- t/T search
- Bracket Commands such as \[d, \]d, \[q, \]q
- Plugin commands, triggered trough normal mode

## 🛠️ How it works?
All normal mode input is tracked and chunked into commands.
This is done through autocommands which add a keylogger (vim.fn.on_key()) while in normal and operator-pending mode. When a SafeState is reached, the end of the command is detected, and the callback with this command is triggered.
The keylogger is removed in other modes.
By default it puts the command into the "x" register. To repeat the command call "@x".
The following commands are not stored by choice.
- commands which only use a single keystroke
- commands starting with <CR> / Enter
- commands which call the macro_key, therefore triggering a recursive infinite loop.

### 💥 which-key
[which-key](https://github.com/folke/which-key.nvim/tree/main) is an awesome plugin to help you remember all your keybinds.
which-key seems to intercept keystrokes, and sends them again when a full command is reached.
This leads to a duplication in the macro e.g. 4j will be registered as 4j4j.
Dejavu takes care of that by checking for duplication and only applying one half to the command.
During normal macro recording this would not be an issue since which-key turns of while recording a macro in the usual way. Some commands are not fixable though, e.g. surrounding a word with a bracket "saiw'" becomes "saiiw'" with which-key turned on. Fixing this is not trivial, and thus not implemented. 

> [!NOTE]
> Many surround plugins feature dot repeatability all ready.


## 📦 Installation                                              
Use your favorite plugin manager

### [lazy.nvim](https://github.com/folke/lazy.nvim) 

```
{
    'juk3-min/dejavu.nvim',
    opts = {},

}
```

## ⚙️ Configuration
The following options are available and can be passed via opts or in an explicit setup call if other
plugins are required, e.g. [fidget](https://github.com/j-hui/fidget.nvim) for notifications
```
{
    enabled = false,             -- Should the plugin be enabled from the start
    macro_key = 'x',             -- macro_key which is set with the previous command. If a callback is defined, the callback is prioritized
    callback = function(command) -- Callback which is triggered when a command is detected
      vim.fn.setreg('x', command)
    end,
    notify = vim.notify,         -- function to notify with. 
    which_key = false,           -- Is which-key installed? If false dejavu also checks by itself
}
```

### Examples
Using config in this case is necessary to use fidget for notifications.
```
  {
    'juk3-min/dejavu.nvim',
    dependencies = { 'j-hui/fidget.nvim' },
    config = function()
      require('dejavu').setup {
        notify = require('fidget').notification.notify,
      }
    end,
  },
```

To turn of notifications use
```
        notify = function(_) end,  
```

or a simple setup to simply print the last command and enable the plugin from the start
```
 {
    'juk3-min/dejavu.nvim',
    opts = {
      callback = function(x)
        vim.print(x)
      end,
      enabled = true,
    },
```


## 🧾 Commands
dejavu creates three commands to use.
To toggle dejavu
:DejavuToggle

To turn it on
:DejavuOn

To turn it off
:DejavuOff

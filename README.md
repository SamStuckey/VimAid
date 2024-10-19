# VimAid Plugin

![5BD0607D-9922-42C7-B29E-0CC131ACB802_1_102_o](https://github.com/user-attachments/assets/a9458294-bd64-42ae-bc56-7e709e21764b)

## Overview
VimAid is a lightweight Neovim plugin that opens a modal window connected to `aider-chat`, enabling you to ask questions directly about the file you're currently working on. Its goal is to streamline the process of querying and interacting with `aider-chat` for code assistance, without leaving your Neovim environment.

## Features
- **Aider-Chat Integration**: Opens a modal terminal in Neovim where you can directly ask questions about your active file in `aider-chat`.
- **Context-Aware Queries**: Easily ask questions about the current file, such as "What does this file do?" or "How can I optimize this function?"
- **Simple Workflow**: With a single command (`:Aid`), you can load your current file into `aider-chat` and immediately start interacting.

## Installation

### Prerequisites
To use VimAid, you'll need the following installed and set up on your machine:

1. **Neovim** (v0.5 or higher)
   - Neovim is required for its floating terminal support. To install Neovim, follow the instructions for your operating system:
     - [Neovim Installation Guide](https://github.com/neovim/neovim/wiki/Installing-Neovim)

2. **Tmux** (v3.0 or higher)
   - Tmux is used for managing sessions within the plugin. You can install Tmux using your system's package manager:
     - [Tmux GitHub Repository and Installation Instructions](https://github.com/tmux/tmux)
     - Example installation via Homebrew (macOS):
       ```bash
       brew install tmux
       ```
   - **Note:** If you're using **iTerm2** on macOS, tmux is already integrated and no further configuration is necessary. You can use tmux within iTerm2 without needing to install it separately.

3. **Aider-Chat** (Local Setup)
   - Aider-Chat must be installed and working on your local machine. Follow the guide on how to set up Aider:
     - [Aider Installation Guide](https://aider.chat) (or a relevant URL to the official Aider setup guide).

Once you have these prerequisites installed and configured, you're ready to install VimAid.

### Using Vim-Plug
1. Add the following line to your `init.vim` or `.vimrc`:

    ```vim
    Plug 'SamStuckey/VimAid'
    ```

2. Run the following command in Neovim to install the plugin:

    ```vim
    :PlugInstall
    ```

### Using Packer
1. Add the following line to your `init.lua` or `init.vim`:

    ```lua
    use 'SamStuckey/VimAid'
    ```

2. Run the following command in Neovim to install the plugin:

    ```vim
    :PackerSync
    ```

### Using Pathogen
1. Navigate to your `bundle` directory:

    ```bash
    cd ~/.vim/bundle
    ```

2. Clone the VimAid repository:

    ```bash
    git clone https://github.com/SamStuckey/VimAid.git
    ```

3. Make sure Pathogen is correctly set up in your `.vimrc`:

    ```vim
    execute pathogen#infect()
    ```

## Usage

### Command
- `:Aid`: This command opens a floating terminal window, runs `aider-chat`, and automatically loads the file you're currently working on in Neovim into the `aider-chat` session. Once the modal is open, you can ask questions like:
  - *"What does this file do?"*
  - *"How can I refactor this method?"*
  - *"Are there any syntax errors in this file?"*
  - Additionally, `aider-chat` can **make changes to your file** and even **commit those changes**. This allows for a seamless workflow where you not only receive suggestions but can also apply those suggestions directly.

If you're interested in learning more about what `aider-chat` can and cannot do, please refer to the [Aider-Chat Documentation](https://aider.chat/docs) for detailed information.

### Example Workflow
1. Open a file in Neovim, e.g., `my_file.rb`.
2. If you have a question about the file, simply run `:Aid`.
3. The plugin will open `aider-chat` in a floating terminal with `my_file.rb` already loaded.
4. You can now ask `aider-chat` questions directly, like "What does this file do?" or even instruct it to modify the file and commit changes.

### Custom Key Mapping
VimAid runs in a terminal mode modal, and by default, closing the modal requires a lengthy key sequence: `Cmd+Leader`, `Cmd+n`, `:q`, `<CR>`. To streamline this, you can use the variable `g:vimaid_close_modal_mapping` to define a custom key mapping that allows you to quickly close the modal with a single command.

For example, in your `vimrc` (or equivalent), you can define the following:

```vim
let g:vimaid_close_modal_mapping = '<C-a>'
nnoremap <C-a> :Aid<CR>
```

This mapping allows you to use `Ctrl + A` to quickly close the modal and return to your normal workflow, avoiding the default key sequence.

You can replace `<C-a>` with any key combination of your choice to suit your preferences.

### Default Key Mapping
If you prefer to use the default key mapping, simply run the command `:Aid` or define your own mappings like so:

```vim
nnoremap <Leader>aid :Aid<CR>
```

## Contributing
This is a small personal project, and at the moment, contributions are not being accepted.


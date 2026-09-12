if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting
    fish_config theme choose catppuccin-macchiato

    if command -q starship
        starship init fish | source
    end

    set fzf_fd_opts --hidden
    fzf_configure_bindings --directory=ctrl-o
    set -gx VISUAL helix
    set -gx EDITOR helix
    alias hx helix
    bind alt-e true
    bind alt-v true
    fish_add_path ~/.cargo/bin
    mise activate fish | source
    niri completions fish | source
    noctalia completions fish | source
end

# added a comment

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/filedesless/.lmstudio/bin
# End of LM Studio CLI section

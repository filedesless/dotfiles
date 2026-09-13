if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting
    fish_config theme choose catppuccin-macchiato

    if command -q starship
        starship init fish | source
    end

    if type -q fzf
        set fzf_fd_opts --hidden
    end
    fzf_configure_bindings --directory=ctrl-o
    alias hx helix
    bind alt-e true
    bind alt-v true
    fish_add_path ~/.cargo/bin
    if type -q mise
        mise activate fish | source
    end
    if type -q niri
        niri completions fish | source
    end
    if type -q noctalia
        noctalia completions fish | source
    end
end

set -gx VISUAL helix
set -gx EDITOR helix

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/filedesless/.lmstudio/bin
# End of LM Studio CLI section

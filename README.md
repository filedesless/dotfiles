# dotfiles

## On OSX

Install Emacs on OSX

    brew tap railwaycat/emacsmacport
    brew cask install emacs-mac-spacemacs-icon
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
    
Install coreutils

    brew install coreutils
    
Install zsh-autosuggestions

    brew install zsh-autosuggestions
    
Install yabai tiling wm [wiki](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release))

    # install skhd
    brew install koekeishiya/formulae/skhd
    brew services start skhd
    
    brew install koekeishiya/formulae/yabai
    # install the scripting addition
    sudo yabai --install-sa
    # start yabai
    brew services start yabai

    # load the scripting addition
    killall Dock
    
    # install spacebar
    brew install cmacrae/formulae/spacebar
    brew services start spacebar 

Install iTerm2

    brew cask install iterm2
    
## Installing most configs

	./install

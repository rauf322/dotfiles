ƒ# dotfiles

My small collection of dotfiles, where I aim to implement unique features that weren't available before.

<img width="1512" alt="skethybar" src="https://github.com/rauf322/dotfiles/blob/main/content%20/sketchybar.png">


* [Aerospace](https://github.com/rauf322/dotfiles/tree/main/.config/aerospace)
* [Alacritty](https://github.com/rauf322/dotfiles/tree/main/.config/alacritty)
* [Sketchybar](https://github.com/rauf322/dotfiles/tree/main/.config/sketchybar)
* [.zshrc](https://github.com/rauf322/dotfiles/blob/main/.zshrc)


## Step 1: Set up zsh as a main shell

1. Check if Zsh is already installed
```zsh
zsh --version #zsh 5.7.1 (x86_64-apple-darwin19.0)
```
2. Set Zsh as the default shell (if it's not already)
First, ensure that Zsh is available in the list of shells by running:
```zsh
cat /etc/shells
```
This will list all the available shells on your system. You should see something like /bin/zsh in the list.
If Zsh is not set as your default shell, you can change it by running:
```zsh
chsh -s /bin/zsh
```
## Step 2: Install Homebrew

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Step 3: Install Sketchybar and Aerospace

1. Install Aerospace
```zsh
brew install --cask aerospace
```

2. Install sketchybar
```zsh
brew tap felixkratz/formulae
brew install sketchybar
```
## Some animation examples

https://github.com/user-attachments/assets/b7f14052-8419-4aa0-96b3-68bbfcc6d08b

case "$(uname -s)" in
  Darwin)
    [[ -f "$HOME/.zshrc.macos" ]] && source "$HOME/.zshrc.macos"
    ;;
  Linux)
    [[ -f "$HOME/.zshrc.linux" ]] && source "$HOME/.zshrc.linux"
    ;;
esac

[[ -f "$HOME/.zshrc.work" ]] && source "$HOME/.zshrc.work"

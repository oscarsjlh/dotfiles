MOZ_ENABLE_WAYLAND=1
export GREENLIGHT_DB_DSN='postgres://greenlight:pa55word@localhost/greenlight?sslmode=disable'
eval "$(starship init zsh)"
alias wgup="wg-quick up wg0"
alias wgdo="wg-quick down wg0"
alias vi='nvim'
alias p='python'
alias gcf='. /home/oscar/scripts/git.sh'
alias eivm='nvim ~/.config/nvim/init.lua'
alias dns='sudo systemctl restart systemd-resolved' 
alias k=kubectl
alias ccr="gcloud compute ssh cucumber --project=cucumber-378516  --zone=europe-west2-c --tunnel-through-iap"
alias gf="ssh root@grafana.uk.natoora.com" 
alias fr="ssh root@radius.natoora.com" 
export VISUAL="nvim"
export EDITOR="$VISUAL"
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH="$PATH:/home/oscar/.local/bin"

SAVEIFS=$IFS
IFS="$(printf '\n\t')"

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar) unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip) unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace) unace x ./"$n"      ;;
            *.zpaq)      zpaq x ./"$n"      ;;
            *.arc)       arc e ./"$n"       ;;
            *.cso)       ciso 0 ./"$n" ./"$n.iso" && \
                              extract $n.iso && \rm -f $n ;;
            *.zlib)      zlib-flate -uncompress < ./"$n" > ./"$n.tmp" && \
                              mv ./"$n.tmp" ./"${n%.*zlib}" && rm -f "$n"   ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

IFS=$SAVEIFS
function pomo() {
    arg1=$1
    shift
    args="$*"

    min=${arg1:?Example: pomo 15 Take a break}
    sec=$((min * 60))
    msg="${args:?Example: pomo 15 Take a break}"

    while true; do
        date '+%H:%M' && sleep "${sec:?}" && notify-send -u critical -t 0 -a pomo "${msg:?}"
    done
}
eval "$(zoxide init zsh)"
alias config='/usr/bin/git --git-dir=/home/oscar/.cfg/ --work-tree=/home/oscar'

### Pugins

   source /usr/share/fzf/key-bindings.zsh


   source /usr/share/fzf/completion.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

autoload -Uz compinit
compinit
source <(kubectl completion zsh)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/oscar/google-cloud-sdk/path.zsh.inc' ]; then . '/home/oscar/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/oscar/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/oscar/google-cloud-sdk/completion.zsh.inc'; fi

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
fpath=(~/.zsh/completion $fpath)


export GREENLIGHT_DB_DSN='postgres://greenlight:pa55word@localhost/greenlight?sslmode=disable'

###################################################################################################
############################################## ZSHRC ##############################################
###################################################################################################

# terminal emulator specific settings
[[ "$TERM" == "xterm-kitty" && -f "$ZDOTDIR/kitty.zsh" ]] && source "$ZDOTDIR/kitty.zsh"

# source Powerlevel10k's instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# set the directory where the plugins are stored
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/zinit/"

# download Zinit if it's not here yet and source it
if [[ ! -d "$ZINIT_HOME" ]]; then
	mkdir -p "$(dirname "$ZINIT_HOME")"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# plugins
zinit light Aloxaf/fzf-tab # needs to load before fast-syntax-highlighting
zinit light hlissner/zsh-autopair
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit ice depth=1; zinit light romkatv/powerlevel10k


# completions
zstyle ':completion:*'                 matcher-list "m:{a-z}={A-Za-z}"
zstyle ':completion:*'                 complete-options true
zstyle ':completion:*'                 menu no
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:git-checkout:*'  sort false
zstyle ':completion:*:git-rebase:*'    sort false
zstyle ':completion:*:descriptions'    format '[%d]'
export LS_COLORS='
di=1;34:\
ln=1;32:\
mh=00:\
pi=33:\
so=35:\
do=1;35:\
bd=1;33:\
cd=1;33:\
or=1;31:\
mi=0;5;31:\
su=0;41:\
sg=0;46:\
ca=30;41:\
tw=0;42:\
ow=34;42:\
st=37;44:\
ex=1;32:\
*.jpg=1;35:\
*.jpeg=1;35:\
*.png=1;35:\
*.gif=1;35:\
*.bmp=1;35:\
*.webp=1;35:\
*.mp4=1;35:\
*.mkv=1;35:\
*.avi=1;35:\
*.mov=1;35:\
*.mp3=1;36:\
*.flac=1;36:\
*.wav=1;36:\
*.ogg=1;36:\
*.opus=1;36:\
*.pdf=1;32:\
*.doc=1;32:\
*.docx=1;32:\
*.odt=1;32:\
*.tar=1;31:\
*.tgz=1;31:\
*.zip=1;31:\
*.rar=1;31:\
*.gz=1;31:\
*.xz=1;31:\
*.7z=1;31:\
*.c=1;33:\
*.cpp=1;33:\
*.h=1;33:\
*.hpp=1;33:\
*.py=1;33:\
*.java=1;33:\
*.rs=1;33'
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*:options' list-colors '=^(-- *)=34'

zstyle ':fzf-tab:complete:*'                  fzf-preview '/usr/local/bin/fzf_preview_wrapper ${realpath:-$word}'
zstyle ':fzf-tab:complete:(\\|*/|)man:*'      fzf-preview 'man $word'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:kill:*'             popup-pad   0 3
zstyle ':fzf-tab:complete:*:options'          fzf-flags --preview=""
zstyle ':fzf-tab:complete:*:argument-1'       fzf-flags --preview=""
zstyle ':fzf-tab:complete:tmux:*'             fzf-flags --preview=""
zstyle ':fzf-tab:*:git-checkout:*'            fzf-flags --preview=""
zstyle ':fzf-tab:*:git-rebase:*'              fzf-flags --preview=""

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*'                fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*'               fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
esac'

# load completions
autoload -Uz compinit && compinit
zinit cdreplay -q


# options
setopt correct  # correction for invalid command names
setopt rcquotes # escape single quotes with '' instead of '\'' in singly quoted strings
setopt globdots # show dotfiles on tab completion

# history
HISTSIZE=10000
HISTFILE=$HOME/.local/state/zsh/zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
HIST_STAMPS="dd/mm/yyyy"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# Vi mode and cursor style
bindkey -v # enable vi keybindings
export KEYTIMEOUT=1 # time in ms to wait for key sequences
zle_highlight=(region:bg="#223249" fg=15) # visual mode highlight color

function zle-keymap-select() {
	local _shape=6
	case "${KEYMAP}" in
		vicmd)
			case "${REGION_ACTIVE}" in
				1) _shape=2 ;; # visual mode: block
				2) _shape=2 ;; # V-line mode: block
				*) _shape=2 ;; # normal mode: block
			esac
			;;
		viins|main)
			if [[ "${ZLE_STATE}" == *overwrite* ]]; then
				_shape=4 # replace mode: underline
			else
				_shape=6 # insert mode: beam
			fi
			;;
		viopp) _shape=0 ;; # operator pending mode: blinking block
		visual) _shape=2 ;; # visual mode: block
	esac
	printf $'\e[%d q' ${_shape}
}
zle -N zle-keymap-select

_set_cursor_beam() {
	echo -ne '\e[6 q'
}
precmd_functions+=(_set_cursor_beam)


# keybindings
bindkey "^p"   history-search-backward
bindkey "^n"   history-search-forward
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

bindkey "\cb"  .beginning-of-line
bindkey "\ce"  .end-of-line
bindkey "\ei"  .beginning-of-line
bindkey "\ea"  .end-of-line
bindkey "\ef"  .forward-word
bindkey "\eb"  .backward-word

bindkey "\ee"  autosuggest-accept

bindkey -a -r  ':' # disable vicmd mode
bindkey "^?"   backward-delete-char # fix backspace in insert mode


# setup programs
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"
[[ -f "$ZDOTDIR/p10k.zsh" ]] && source "$ZDOTDIR/p10k.zsh"

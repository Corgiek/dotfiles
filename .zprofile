emulate sh -c 'source /etc/profile'

export VISUAL=nvim
export EDITOR=nvim
export PATH="/home/corg/.local/bin:$PATH"
export TCELL_TRUECOLOR=on
export MESA_GLTHREAD=true
export QT_QPA_PLATFORM=wayland-egl
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
#export SDL_VIDEODRIVER=wayland
export OSONE_PLATFORM=wayland
export WLR_RENDERER=vulkan
export MOZ_ENABLE_WAYLAND=1
export MOZ_DISABLE_RDD_SANDBOX=1
export MOZ_WEBRENDER=1
export MOZ_ACCELERATED=1
export _JAVA_AWT_WM_NONREPARENTING=1
export LESSHISTFILE=-
export LESS='-R --mouse'
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
export XDG_DOWNLOAD_DIR="$HOME/downloads"
export XDG_MUSIC_DIR="$HOME/music"
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export GOPATH="${XDG_DATA_HOME}/go"
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_TYPE=Hyprland
export QT_QPA_PLATFORMTHEME=qt5ct
export BEMENU_OPTS="-b -H20 -n --fn 'Ubuntu 10' --tb '#1c1c1c' --tf '#dfdfaf' --hb '#af5f5f' --hf '#1c1c1c' --nb '#1c1c1c' --fbb '#1c1c1c' "

if [ -z "$XDG_RUNTIME_DIR" ]; then
	export XDG_RUNTIME_DIR="/tmp/$UID-runtime-dir"
	if ! [ -d "$XDG_RUNTIME_DIR" ]; then
		mkdir "$XDG_RUNTIME_DIR"
		chmod 0700 "$XDG_RUNTIME_DIR"
	fi
fi


if [ "$(tty)" = "/dev/tty1" ]; then
	if [ "$(command -v Hyprland)" ]; then
		exec Hyprland
	fi	
fi

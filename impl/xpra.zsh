local _FB_XRL_XPRA_PATH="${FB_XRL_ID#ssh://}"
[[ $FB_XRL_ID == $_FB_XRL_XPRA_PATH ]] && _fb_xrl_error FB_XRL_ID "$FB_XRL_ID" must be start with ssh://
_FB_XRL_SSH_HOST="${_FB_XRL_XPRA_PATH:h}"
local _FB_XRL_DISPLAY="${_FB_XRL_XPRA_PATH:t}"
[[ _FB_XRL_DISPLAY == $_FB_XRL_SSH_HOST ]] && _fb_xrl_error cannot find DISPLAY from FB_XRL_ID "$FB_XRL_ID"

# _FB_XRL_SCREEN_SESSION must not contains illegal character '/'
local _FB_XRL_SCREEN_SESSION="xrl-$_FB_XRL_SSH_HOST-$_FB_XRL_DISPLAY"

_FB_XRL_FUNCTIONS+=$(cat <<EOF
_fb_xrl_initialized(){
  if ! [[ -d /run/user/\$(id -u)/xpra/$_FB_XRL_DISPLAY ]] {
    return 1
  }

  if ! [[ \$(sed -n 's/^--start=//p' /run/user/\$(id -u)/xpra/$_FB_XRL_DISPLAY/cmdline) == *screen* ]] {
    echo xpra session start command is mismatch
    return 1
  }

  if ! {screen -ls "$_FB_XRL_SCREEN_SESSION" > /dev/null} {
    echo cannot found screen session "$_FB_XRL_SCREEN_SESSION"
    return 1
  }

  return 0
}

_fb_xrl_init(){
  if [[ -d /run/user/\$(id -u)/xpra/$_FB_XRL_DISPLAY ]] {
    echo stopping previous display
    xpra stop :$_FB_XRL_DISPLAY --start='script -ec "setsid screen -dmS $_FB_XRL_SCREEN_SESSION" /dev/null' --input-method=fcitx --start="fcitx5 -r"
  }
  echo starting display
  xpra start :$_FB_XRL_DISPLAY --start='script -ec "setsid screen -dmS $_FB_XRL_SCREEN_SESSION" /dev/null' --input-method=fcitx --start="fcitx5 -r"
  while ! {screen -ls "$_FB_XRL_SCREEN_SESSION" > /dev/null} {
    sleep 1
  }
}

_fb_xrl_run(){
  env DISPLAY=:$_FB_XRL_DISPLAY "\$@"
}
EOF
)

_fb_xrl_attached(){
  if ! { pgrep -f "xpra attach $FB_XRL_ID" > /dev/null} {
    return 1
  }
  return 0
}

_fb_xrl_attach(){
  xpra attach $FB_XRL_ID &
}

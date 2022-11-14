#!/bin/zsh

_fb_xrl_error(){
  echo "$@" 1>&2;
  exit 1
}
#
[[ -z "$FB_XRL_WARPPER" ]] && _fb_xrl_error env FB_XRL_WARPPER not set
[[ -z "$FB_XRL_ID" ]] && _fb_xrl_error env FB_XRL_ID not set
[[ -z "$FB_XRL_VGL_WHITELIST" ]] &&
    FB_XRL_VGL_WHITELIST=(
        'google-chrome'
        'alacritty'
    )

local _FB_XRL_SSH_HOST

local _FB_XRL_FUNCTIONS=""

local _FB_XRL_IMPL="${0:a:h}/impl/$FB_XRL_WARPPER.zsh"
if ! [[ -f $_FB_XRL_IMPL ]] {
    _fb_xrl_error FB_XRL_WARPPER $FB_XRL_WARPPER is not supported
}

source $_FB_XRL_IMPL

ssh "$_FB_XRL_SSH_HOST" 'zsh -s' <<EOF
$_FB_XRL_FUNCTIONS

if ! {_fb_xrl_initialized} {
  _fb_xrl_init
}
EOF

if ! {_fb_xrl_attached} {
  _fb_xrl_attach
}

# FIXME skip sudo
# FIXME backslash
local _FB_XRL_CMD=$1
local _FB_XRL_RUN=()
if (( $FB_XRL_VGL_WHITELIST[(I)$_FB_XRL_CMD] )) {
  _FB_XRL_RUN+=vglrun
}
_FB_XRL_RUN+=($@)

ssh "$_FB_XRL_SSH_HOST" 'zsh -s' <<EOF
$_FB_XRL_FUNCTIONS

echo running $_FB_XRL_RUN
_fb_xrl_run $_FB_XRL_RUN
EOF

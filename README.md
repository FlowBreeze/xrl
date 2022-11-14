xrl
===

xrl(X remote launcher) is a tool that warps X Remote Desktop(such as xpra) to launch remote application on local X server

## Configuration

### basic

 | environments         | description                                                                            |
|----------------------|----------------------------------------------------------------------------------------|
| FB_XRL_WARPPER       | the actual tool to manage remote desktop, can be `xpra`                                |
| FB_XRL_ID            | identify the session connected by `$FB_XRL_WARPPER`, will be different on each warpper |
 | FB_XRL_VGL_WHITELIST | a zsh array that contains command run in `vglrun`                                      |

### Warppers

| name                                     | FB_XRL_ID               |
|------------------------------------------|-------------------------|
| [xpra](https://github.com/Xpra-org/xpra) | ssh://USER@HOST/DISPLAY |

 

## Usage
`xrl <command> [...args]` 

launch remote application on local X server: 
```shell
xrl urxvt
```
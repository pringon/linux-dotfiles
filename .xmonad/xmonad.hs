-- My Xmonad configuration 
--
-- Template was copied from the archive at:
-- https://wiki.haskell.org/Xmonad/Config_archive

-- IMPORTS

import XMonad
import XMonad.Actions.Submap
import XMonad.Util.SpawnOnce

import qualified XMonad.StackSet as W

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import qualified XMonad.Layout.Fullscreen as Fullscreen
import XMonad.Layout.ThreeColumns

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

import qualified Data.Map        as M

import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

main :: IO ()
main = do
    dbus <- D.connectSession
    -- Request access to the DBus name
    _ <- D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    xmonad . ewmh . docks $ def
        { terminal           = "termite"
        , workspaces         = myWorkspaces
        , modMask            = mod4Mask
        , normalBorderColor  = "#dddddd"
        , focusedBorderColor = "#d92a07"
        , borderWidth        = 2
        -- Whether focus follows the mouse pointer.
        , focusFollowsMouse  = True
        -- key bindings
        , keys               = myKeys
        , mouseBindings      = myMouseBindings
        -- hooks, layouts
        , layoutHook         = windowGaps $ avoidStruts myLayout
        , logHook            = dynamicLogWithPP (myLogHook dbus)
        , startupHook        = myStartupHook
        , manageHook         = Fullscreen.fullscreenManageHook
        , handleEventHook    = Fullscreen.fullscreenEventHook
        }
    where
        windowGaps = spacingRaw True (Border 0 0 0 0) False (Border 0 5 5 0) True
        myWorkspaces = ["1: 💻","2: 📖","3","4","5","6","7","8: 🧑🧑","9: 🎵"]


-----------------
--- KEY BINDINGS
-----------------
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- terminal
    [ ((modm .|. shiftMask, xK_Return ), spawn $ XMonad.terminal conf)
    -- application launcher
    , ((modm              ,  xK_d     ), spawn "rofi -show drun -config ./.config/rofi/color-scheme.conf")
    -- search through open windows
    , ((modm              ,  xK_s     ), spawn "rofi -show window -config ./.config/rofi/color-scheme.conf")
    -- close focused window
    , ((modm .|. shiftMask, xK_q      ), kill)
     -- Rotate through the available layout algorithms
    , ((modm              , xK_space  ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space  ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n      ), refresh)
    -- Move focus to the next window
    , ((modm,               xK_Tab    ), windows W.focusDown)
    -- Move focus to the next window
    , ((modm,               xK_j      ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modm,               xK_k      ), windows W.focusUp  )
    -- Move focus to the master window
    , ((modm,               xK_m      ), windows W.focusMaster  )
    -- Swap the focused window and the master window
    , ((modm              , xK_Return ), windows W.shiftMaster)
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j      ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k      ), windows W.swapUp    )
    -- Shrink the master area
    , ((modm,               xK_h      ), sendMessage Shrink)
    -- Expand the master area
    , ((modm,               xK_l      ), sendMessage Expand)
    -- Push window back into tiling
    , ((modm,               xK_t      ), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma  ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period ), sendMessage (IncMasterN (-1)))
    -- Recompile and reload xmonad config
    , ((modm              , xK_q      ), notifyRebuildModeOptions)
    , ((modm              , xK_b     ), sendMessage ToggleStruts)
    -- Volume control
    -- XF86AudioRaiseVolume
    , ((0                , 0x1008ff13), spawn "pactl -- set-sink-volume 0 +5%")
    -- XF86AudioLowerVolume
    , ((0                , 0x1008ff11), spawn "pactl -- set-sink-volume 0 -5%")
    -- XF86AudioMute
    , ((0                , 0x1008ff12), spawn "pactl set-sink-mute 0 toggle")
    -- Power mode
    , ((modm             , xK_p      ), notifyPowerModeOptions)
    ]
    ++
    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

notifyPowerModeOptions :: X ()
notifyPowerModeOptions = do
  spawn $ "notify-send -t 2000 \"Power Mode\" \"" ++ powerModeNotificationBody ++ "\""
  submap powerModeOptions
  where
    powerModeNotificationBody = "The following options are available\n\
                                \Lock: L\n\
                                \Reboot: R\n\
                                \Exit: E\n\
                                \Suspend: S\n\
                                \Shutdown: Shift + S\n\
                                \Cancel: Esc"
    powerModeOptions = M.fromList [((0        , xK_l), spawn "./.config/i3/scripts/lock.sh")
                                  ,((0        , xK_r), spawn "reboot")
                                  ,((0        , xK_e), spawn "kill -9 -1")
                                  ,((0        , xK_s), spawn "./.config/i3/scripts/suspend.sh")
                                  ,((shiftMask, xK_s), spawn "poweroff")
                                  ]

notifyRebuildModeOptions :: X ()
notifyRebuildModeOptions = do
  spawn $ "notify-send -t 2000 \"Rebuild Mode\" \"" ++ rebuildModeNotificationBody ++ "\""
  submap rebuildModeOptions
  where
    rebuildModeNotificationBody = "The folowing options are available\n\
                                  \WM: W\n\
                                  \Binaries: B\n\
                                  \Cancel: Esc"
    rebuildModeOptions = M.fromList [((0, xK_w), spawn "./bin/rebuild-xmonad")
                                    ,((0, xK_b), spawn "./bin/rebuild-bin && notify-send -t 2000 \"Binaries rebuilt\"")
                                    ]

------------------
-- MOUSE BINDINGS
------------------
myMouseBindings :: XConfig l -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]


---------------
--- LAYOUTS
---------------
myLayout = (reflectHoriz tiled) ||| (Mirror tiled) ||| threeCol ||| fullscreen
  where
    -- Split the screen into two columns, one master and one slave
    tiled      = Tall nmaster delta ratio
    -- Split the screen into three segments (one master and two slaves)
    -- The master is in the centre
    threeCol   = reflectHoriz $ ThreeColMid nmaster delta ratio
    fullscreen = Fullscreen.fullscreenFull $ noBorders Full

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100


------------
-- INIT
--------------
myStartupHook :: X ()
myStartupHook = do
  spawnOnce "setxkbmap gb -option caps:swapescape"
  spawnOnce "xset r rate 300"
  spawnOnce "redshift -O 3000"
  spawnOnce "polybar -c ~/.config/polybar/config xmonad-status -r &"
  -- Start compositor
  spawnOnce "picom &"
  spawnOnce "nitrogen --restore &"
  spawnOnce "emacs --daemon"


-----------------------------------
-- STATUS BAR STUFF (DBUS related)
-----------------------------------

myLogHook :: D.Client -> PP
myLogHook dbus = def { ppOutput = dbusOutput dbus }

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
    where
        objectPath = D.objectPath_ "/org/xmonad/Log"
        interfaceName = D.interfaceName_ "org.xmonad.Log"
        memberName = D.memberName_ "Update"

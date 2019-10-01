import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.CopyWindow(copy)
import XMonad.Hooks.WallpaperSetter
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import System.Exit

term :: String
term = "urxvt -bg black -tr -fg white -fn \"xft:Droid Sans Mono:pixelsize=15\" +sb -sh 25"

--layout = avoidStruts $ layoutHook defaultConfig
layout = spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $
  gaps [(U,10), (R,10), (L,10), (D,10)] $ Tall 1 (1/2) (1/2) ||| Full

myModMask :: KeyMask
myModMask = mod4Mask

-- | The xmonad key bindings. Add, modify or remove key bindings here.
--
-- (The comment formatting character is used when generating the manpage)
--
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@XConfig {XMonad.modMask = modMask} = M.fromList $
    -- launching and killing programs
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf) -- %! Launch terminal
    , ((modMask,               xK_p     ), spawn "dmenu_run") -- %! Launch dmenu
    , ((modMask .|. shiftMask, xK_p     ), spawn "gmrun") -- %! Launch gmrun
    , ((modMask .|. shiftMask, xK_c     ), kill) -- %! Close the focused window

    , ((modMask,               xK_space ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts on the current workspace to default

    , ((modMask,               xK_n     ), refresh) -- %! Resize viewed windows to the correct size

    -- move focus up or down the window stack
    , ((modMask,               xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_j     ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask,               xK_k     ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window

    -- modifying the window order
    , ((modMask,               xK_Return), windows W.swapMaster) -- %! Swap the focused window and the master window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    ) -- %! Swap the focused window with the previous window

    -- resizing the master/slave ratio
    , ((modMask,               xK_h     ), sendMessage Shrink) -- %! Shrink the master area
    , ((modMask,               xK_l     ), sendMessage Expand) -- %! Expand the master area

    -- floating layer support
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink) -- %! Push window back into tiling

    -- increase or decrease number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

    -- quit, or restart
    , ((modMask .|. shiftMask, xK_q     ), io exitSuccess) -- %! Quit xmonad
    , ((modMask              , xK_q     ), spawn "if type xmonad; then xmonad --recompile && pkill xmobar && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad

    , ((modMask .|. shiftMask, xK_slash ), helpCommand) -- %! Run xmessage with a summary of the default keybindings (useful for beginners)
    -- repeat the binding for non-American layout keyboards
    , ((modMask              , xK_question), helpCommand) -- %! Run xmessage with a summary of the default keybindings (useful for beginners)
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]



    ++
    -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    ++

    -- dynamic workspaces
    [ ((modMask .|. shiftMask, xK_BackSpace), removeWorkspace)
    , ((modMask .|. shiftMask, xK_v      ), selectWorkspace def)
    , ((modMask, xK_m                    ), withWorkspace def (windows . W.shift))
    , ((modMask .|. shiftMask, xK_m      ), withWorkspace def (windows . copy))
    , ((modMask .|. shiftMask, xK_r      ), renameWorkspace def) ]

    ++

    -- mod-[1..9]       %! Switch to workspace N in the list of workspaces
    -- mod-shift-[1..9] %! Move client to workspace N in the list of workspaces
    let f c = map (withNthWorkspace c) [0..] in
      zip (zip (repeat modMask) [xK_1..xK_9]) (f W.greedyView)
      ++
      zip (zip (repeat (modMask .|. shiftMask)) [xK_1..xK_9]) (f W.shift)

    ++
    -- Custom key bindings
    [ -- Mute volume.
      ((modMask .|. controlMask, xK_m), spawn "amixer -q set Master toggle")
      -- Decrease volume.
    , ((modMask .|. controlMask, xK_j), spawn "amixer -q set Master 10%-")
      -- Increase volume.
    , ((modMask .|. controlMask, xK_k), spawn "amixer -q set Master 10%+")
      -- Switch keyboard layout
    , ((modMask .|. controlMask, xK_space), spawn switchLayout)
    ]
  where
    helpCommand :: X ()
    helpCommand = spawn ("echo -e " ++ show help ++ " | xmessage -file -")
    switchLayout = "setxkbmap -query | egrep -q \"layout:\\s+us\" "
      ++ " && setxkbmap -layout ca || setxkbmap -layout us"

main :: IO ()
main = do
  spawn "xmobar ~/.xmobar/.bottombarrc"
  xmonad =<< topBar def
         { manageHook = manageDocks <+> manageHook def
         , layoutHook = avoidStruts layout
         , modMask = myModMask
         , terminal = term
         , workspaces = myWorkspaces
         , keys = myKeys
         , logHook = wallpaperSetter defWallpaperConf {
             wallpapers = WallpaperList
               [ (workspace, WallpaperDir "") | workspace <- myWorkspaces ]
             }
         }
  where
    topBar = statusBar "xmobar ~/.xmobar/.topbarrc" xmobarPP toggleStrutsKey
    toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b)
    myWorkspaces = ["1:term", "2:web", "3:mail", "4:media" ]

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "",
    "-- Workspaces & screens",
    "mod-[1..9]         Switch to workSpace N",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps

term = "urxvt -bg black -tr -fg white -fn \"xft:Droid Sans Mono:pixelsize=15\" +sb -sh 25"
--layout = avoidStruts $ layoutHook defaultConfig
layout = spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $
  gaps [(U,10), (R,10), (L,10), (D,10)] $ Tall 1 (1/2) (1/2) ||| Full


main = xmonad =<< xmobar defaultConfig
         { manageHook = manageDocks <+> manageHook defaultConfig
	 , layoutHook = avoidStruts layout
	 , modMask = mod4Mask
	 , terminal = term
         , workspaces = ["1:term", "2:web", "3:mail", "4:media", "5:scratch", "6:scratch"]
	 }

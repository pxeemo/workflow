 -- Base
import XMonad
--import System.Directory
import System.IO (hClose, hPutStr, hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen, nextWS, prevWS, toggleWS)
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

    -- Hooks
--import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
--import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
--import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
--import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

   -- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP, mkNamedKeymap)
import XMonad.Util.NamedActions
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

import Colors.Dracula

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "kitty"        -- Sets default terminal

myBrowser :: String
myBrowser = "firefox "      -- Sets qutebrowser as browser

myBorderWidth :: Dimension
myBorderWidth = 1           -- Sets border width for windows

myNormColor :: String       -- Border color of normal windows
myNormColor   = color01   -- This variable is imported from Colors.THEME

myFocusColor :: String      -- Border color of focused windows
myFocusColor  = colorBack   -- This variable is imported from Colors.THEME

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
  spawn "killall conky"   -- kill current conky on each restart
  spawn "killall trayer"  -- kill current trayer on each restart
  spawn "xsetroot -cursor_name left-ptr"  -- change to default cursor
  spawn "emacs --daemon"  -- change to default cursor

  spawnOnce "lxsession"
  spawnOnce "picom"
  spawnOnce "nm-applet"
  spawnOnce "setxkbmap -option grp:caps_toggle us,ir"
  spawnOnce "redshift-gtk &"
  --spawnOnce "volumeicon"

  spawn ("sleep 2 && conky -c $HOME/.config/conky/xmonad/" ++ colorScheme ++ "-01.conkyrc")
  spawn ("sleep 2 && trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 " ++ colorTrayer ++ " --height 22")

  spawnOnce "nitrogen --restore &"   -- if you prefer nitrogen to feh
  setWMName "Xmonad"

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "cmus" spawnCmus findCmus manageCmus
                , NS "calculator" spawnCalc findCalc manageCalc ]
  where
    spawnTerm  = myTerminal ++ " --title scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.87
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnCmus  = myTerminal ++ " --title cmus -e cmus"
    findCmus   = title =? "cmus"
    manageCmus = customFloating $ W.RationalRect l t w h
               where
                 h = 0.87
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ limitWindows 5
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ simplestFloat

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = color15
                 , inactiveColor       = color08
                 , activeBorderColor   = color15
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color16 }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
  { swn_font              = "xft:Ubuntu:bold:size=60"
  , swn_fade              = 1.0
  , swn_bgcolor           = "#1c1f24"
  , swn_color             = "#ffffff" }

-- The layout hook
myLayoutHook = avoidStruts
               $ mouseResize
               $ windowArrange
               $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    myDefaultLayout = withBorder myBorderWidth tall
                                           ||| noBorders monocle
                                           ||| floats

-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
myWorkspaces = [" sys ", " www ", " chat ", " dev ", " mus ", " doc ", " vid ", " gfx ", " vbox "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
  -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
  -- I'm doing it this way because otherwise I would have to write out the full
  -- name of my workspaces and the names would be very long if using clickable workspaces.
  [ className =? "confirm"         --> doFloat
  , className =? "file_progress"   --> doFloat
  , className =? "dialog"          --> doFloat
  , className =? "download"        --> doFloat
  , className =? "error"           --> doFloat
  , className =? "Gimp"            --> doFloat
  , className =? "notification"    --> doFloat
  , className =? "pinentry-gtk-2"  --> doFloat
  , className =? "splash"          --> doFloat
  , className =? "toolbar"         --> doFloat
  , className =? "Yad"             --> doCenterFloat
  , title =? "Oracle VM VirtualBox Manager"  --> doFloat
  , title =? "Mozilla Firefox"     --> doShift ( myWorkspaces !! 1 )
  , className =? "Brave-browser"   --> doShift ( myWorkspaces !! 1 )
  , className =? "mpv"             --> doShift ( myWorkspaces !! 7 )
  , className =? "Gimp"            --> doShift ( myWorkspaces !! 8 )
  , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
  , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
  , isFullscreen -->  doFullFloat
  ] <+> namedScratchpadManageHook myScratchPads

soundDir = "/opt/dtos-sounds/" -- The directory that has the sound files

startupSound  = soundDir ++ "startup-01.mp3"
shutdownSound = soundDir ++ "shutdown-01.mp3"
dmenuSound    = soundDir ++ "menu-01.mp3"

subtitle' ::  String -> ((KeyMask, KeySym), NamedAction)
subtitle' x = ((0,0), NamedAction $ map toUpper
                      $ sep ++ "\n-- " ++ x ++ " --\n" ++ sep)
  where
    sep = replicate (6 + length x) '-'

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
  h <- spawnPipe $ "yad --text-info --fontname=\"SauceCodePro Nerd Font Mono 12\" --fore=#46d9ff back=#282c36 --center --geometry=1200x800 --title \"XMonad keybindings\""
  --hPutStr h (unlines $ showKm x) -- showKM adds ">>" before subtitles
  hPutStr h (unlines $ showKmSimple x) -- showKmSimple doesn't add ">>" to subtitles
  hClose h
  return ()

myKeys :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
myKeys c =
  --(subtitle "Custom Keys":) $ mkNamedKeymap c $
  let subKeys str ks = subtitle' str : mkNamedKeymap c ks in
  subKeys "Xmonad Essentials"
  [ ("M-C-r", addName "Recompile XMonad"       $ spawn "xmonad --recompile")
  , ("M-S-r", addName "Restart XMonad"         $ spawn "xmonad --restart")
  , ("M-S-q", addName "Quit XMonad"            $ io exitSuccess)
  , ("M-x", addName "Kill focused window"      $ kill1)
  , ("M-S-x", addName "Kill all windows on WS" $ killAll)
  , ("M-<Delete>", addName "sleep computer"    $ spawn "systemctl suspend")
  , ("M-S-<Return>", addName "Run launcher"    $ spawn "rofi -show drun -show-icons")]

  ^++^ subKeys "Switch to workspace"
  [ ("M-1", addName "Switch to workspace 1"    $ (windows $ W.greedyView $ myWorkspaces !! 0))
  , ("M-2", addName "Switch to workspace 2"    $ (windows $ W.greedyView $ myWorkspaces !! 1))
  , ("M-3", addName "Switch to workspace 3"    $ (windows $ W.greedyView $ myWorkspaces !! 2))
  , ("M-4", addName "Switch to workspace 4"    $ (windows $ W.greedyView $ myWorkspaces !! 3))
  , ("M-5", addName "Switch to workspace 5"    $ (windows $ W.greedyView $ myWorkspaces !! 4))
  , ("M-6", addName "Switch to workspace 6"    $ (windows $ W.greedyView $ myWorkspaces !! 5))
  , ("M-7", addName "Switch to workspace 7"    $ (windows $ W.greedyView $ myWorkspaces !! 6))
  , ("M-8", addName "Switch to workspace 8"    $ (windows $ W.greedyView $ myWorkspaces !! 7))
  , ("M-9", addName "Switch to workspace 9"    $ (windows $ W.greedyView $ myWorkspaces !! 8))]

  ^++^ subKeys "Send window to workspace"
  [ ("M-S-1", addName "Send to workspace 1"    $ (windows $ W.shift $ myWorkspaces !! 0))
  , ("M-S-2", addName "Send to workspace 2"    $ (windows $ W.shift $ myWorkspaces !! 1))
  , ("M-S-3", addName "Send to workspace 3"    $ (windows $ W.shift $ myWorkspaces !! 2))
  , ("M-S-4", addName "Send to workspace 4"    $ (windows $ W.shift $ myWorkspaces !! 3))
  , ("M-S-5", addName "Send to workspace 5"    $ (windows $ W.shift $ myWorkspaces !! 4))
  , ("M-S-6", addName "Send to workspace 6"    $ (windows $ W.shift $ myWorkspaces !! 5))
  , ("M-S-7", addName "Send to workspace 7"    $ (windows $ W.shift $ myWorkspaces !! 6))
  , ("M-S-8", addName "Send to workspace 8"    $ (windows $ W.shift $ myWorkspaces !! 7))
  , ("M-S-9", addName "Send to workspace 9"    $ (windows $ W.shift $ myWorkspaces !! 8))]

  ^++^ subKeys "Move window to WS and go there"
  [ ("M-S-]", addName "Move window to next WS" $ shiftTo Next nonNSP >> moveTo Next nonNSP)
  , ("M-S-[", addName "Move window to prev WS" $ shiftTo Prev nonNSP >> moveTo Prev nonNSP)
  , ("M-]", addName "Move to next WS"          $ nextWS)
  , ("M-[", addName "Move to prev WS"          $ prevWS)
  , ("M-'", addName "Toggle to last WS"        $ toggleWS)]

  ^++^ subKeys "Window navigation"
  [ ("M-j", addName "Move focus to next window"                $ windows W.focusDown)
  , ("M-k", addName "Move focus to prev window"                $ windows W.focusUp)
  , ("M-m", addName "Move focus to master window"              $ windows W.focusMaster)
  , ("M-S-j", addName "Swap focused window with next window"   $ windows W.swapDown)
  , ("M-S-k", addName "Swap focused window with prev window"   $ windows W.swapUp)
  , ("M-S-m", addName "Swap focused window with master window" $ windows W.swapMaster)
  , ("M-<Backspace>", addName "Move focused window to master"  $ promote)
  , ("M-S-,", addName "Rotate all windows except master"       $ rotSlavesDown)
  , ("M-S-.", addName "Rotate all windows current stack"       $ rotAllDown)]

  -- Dmenu scripts (dmscripts)
  -- In Xmonad and many tiling window managers, M-p is the default keybinding to
  -- launch dmenu_run, so I've decided to use M-p plus KEY for these dmenu scripts.
  ^++^ subKeys "Dmenu scripts"
  [ ("M-p p", addName "Run dmenu"              $ spawn "dmenu_run")]

  ^++^ subKeys "Favorite programs"
  [ ("M-<Return>", addName "Launch terminal"   $ spawn (myTerminal))
  , ("M-b", addName "Launch web browser"       $ spawn (myBrowser))
  , ("M-M1-h", addName "Launch htop"           $ spawn (myTerminal ++ " -e htop"))
  , ("M-M1-e", addName "Launch emacs"          $ spawn "emacs &")
  , ("M-t", addName "Launch telegram"          $ spawn "telegram &")]

  -- Switch layouts
  ^++^ subKeys "Switch layouts"
  [ ("M-<Tab>", addName "Switch to next layout"   $ sendMessage NextLayout)
  , ("M-<Space>", addName "Toggle noborders/full" $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)]

  -- Window resizing
  ^++^ subKeys "Window resizing"
  [ ("M-h", addName "Shrink window"               $ sendMessage Shrink)
  , ("M-l", addName "Expand window"               $ sendMessage Expand)
  , ("M-M1-j", addName "Shrink window vertically" $ sendMessage MirrorShrink)
  , ("M-M1-k", addName "Expand window vertically" $ sendMessage MirrorExpand)]

  -- Floating windows
  ^++^ subKeys "Floating windows"
  [ ("M-f", addName "Toggle float layout"        $ sendMessage (T.Toggle "floats"))
  , ("M-t", addName "Sink a floating window"     $ withFocused $ windows . W.sink)
  , ("M-S-t", addName "Sink all floated windows" $ sinkAll)]

  -- Increase/decrease spacing (gaps)
  ^++^ subKeys "Window spacing (gaps)"
  [ ("C-M1-j", addName "Decrease window spacing" $ decWindowSpacing 4)
  , ("C-M1-k", addName "Increase window spacing" $ incWindowSpacing 4)
  , ("C-M1-h", addName "Decrease screen spacing" $ decScreenSpacing 4)
  , ("C-M1-l", addName "Increase screen spacing" $ incScreenSpacing 4)]

  -- Increase/decrease windows in the master pane or the stack
  ^++^ subKeys "Increase/decrease windows in master pane or the stack"
  [ ("M-S-<Up>", addName "Increase clients in master pane"   $ sendMessage (IncMasterN 1))
  , ("M-S-<Down>", addName "Decrease clients in master pane" $ sendMessage (IncMasterN (-1)))
  , ("M-=", addName "Increase max # of windows for layout"   $ increaseLimit)
  , ("M--", addName "Decrease max # of windows for layout"   $ decreaseLimit)]

  -- Scratchpads
  -- Toggle show/hide these programs. They run on a hidden workspace.
  -- When you toggle them to show, it brings them to current workspace.
  -- Toggle them to hide and it sends them back to hidden workspace (NSP).
  ^++^ subKeys "Scratchpads"
  [ ("M-s t", addName "Toggle scratchpad terminal"   $ namedScratchpadAction myScratchPads "terminal")
  , ("M-s m", addName "Toggle scratchpad cmus"       $ namedScratchpadAction myScratchPads "cmus")
  , ("M-s c", addName "Toggle scratchpad calculator" $ namedScratchpadAction myScratchPads "calculator")]

  -- Multimedia Keys
  ^++^ subKeys "Multimedia keys"
  [ ("C-M1-m", addName "Toggle audio mute"            $ spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
  , ("M-<Page_Up>", addName "Raise vol"               $ spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ("M-<Page_Down>", addName "Lower vol"             $ spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
  , ("<Print>", addName "Take full screenshot"        $ spawn "screenshot -f")
  , ("M-<Print>", addName "Take selection screenshot" $ spawn "screenshot -s")
  , ("<Scroll_lock>", addName "toggle backlight"      $ spawn "backlight")]
  -- The following lines are needed for named scratchpads.
    where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
          nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

main :: IO ()
main = do
  -- Launching three instances of xmobar on their monitors.
  xmproc0 <- spawnPipe ("xmobar -x 0 $HOME/.config/xmobar/" ++ colorScheme ++ "-xmobar.hs")
  -- the xmonad, ya know...what the WM is named after!
  xmonad $ addDescrKeys' ((mod4Mask, xK_F1), showKeybindings) myKeys $ ewmh $ docks $ def
    { manageHook         = myManageHook <+> manageDocks
    --, handleEventHook    = docks
                           -- Uncomment this line to enable fullscreen support on things like YouTube/Netflix.
                           -- This works perfect on SINGLE monitor systems. On multi-monitor systems,
                           -- it adds a border around the window if screen does not have focus. So, my solution
                           -- is to use a keybinding to toggle fullscreen noborders instead.  (M-<Space>)
                           -- <+> fullscreenEventHook
    , modMask            = myModMask
    , terminal           = myTerminal
    , startupHook        = myStartupHook
    , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
    , workspaces         = myWorkspaces
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormColor
    , focusedBorderColor = myFocusColor
    , logHook = dynamicLogWithPP $  filterOutWsPP [scratchpadWorkspaceTag] $ xmobarPP
        { ppOutput = \x -> hPutStrLn xmproc0 x                    -- xmobar on monitor 1
        , ppCurrent = xmobarColor color06 "" . wrap
           ("<box type=Bottom width=2 color=" ++ color06 ++ ">") "</box>"
        , ppVisible = xmobarColor color06 "" . clickable          -- Visible but not current workspace
        , ppHidden = xmobarColor color05 "" . wrap                -- Hidden workspace
           ("<box type=Top width=2 color=" ++ color05 ++ ">") "</box>" . clickable
        , ppHiddenNoWindows = xmobarColor color05 ""  . clickable -- Hidden workspaces (no windows)
        , ppTitle = xmobarColor color16 "" . shorten 60           -- Title of active window
        , ppSep =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>"    -- Separator character
        , ppUrgent = xmobarColor color02 "" . wrap "!" "!"        -- Urgent workspace
        , ppExtras  = [windowCount]                               -- Adding # of windows on current workspace to the bar
        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]              -- order of things in xmobar
        }
    }

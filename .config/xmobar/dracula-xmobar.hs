-- Xmobar (http://projects.haskell.org/xmobar/)
-- This is one of the xmobar configurations for DTOS.
-- This config is packaged in the DTOS repo as 'dtos-xmobar'
-- Color scheme: Dracula
-- Dependencies: 
   -- otf-font-awesome 
   -- ttf-mononoki 
   -- ttf-ubuntu-font-family
   -- htop
   -- emacs
   -- pacman (Arch Linux)
   -- trayer
   -- 'dtos-local-bin' (from dtos-core-repo)

Config { font            = "xft:Ubuntu:weight=bold:pixelsize=14:antialias=true:hinting=true"
       , additionalFonts = [ "xft:Mononoki:pixelsize=14:antialias=true:hinting=true"
                           , "xft:Font Awesome 6 Free Solid:pixelsize=14"
                           , "xft:Font Awesome 6 Brands:pixelsize=14" ]
       , bgColor      = "#282a36"
       , fgColor      = "#f8f8f2"
       , position     = TopSize C 100 24
       , lowerOnStart = True
       , hideOnStart  = False
       , allDesktops  = True
       , persistent   = True
       , iconRoot     = ".xmonad/xpm/"  -- default: "."
       , commands = [ Run Com "echo" ["<fn=2>\xf11c</fn>"] "kbd-icon" 3600
		    , Run Kbd [("us","En"),("ir","Fa")]
		    , Run Volume "default:1" "Master" ["-t", "<fn=2><status></fn> <volume>%", "--",
                                                       "-O", "\xf028",
                                                       "-o", "\xf6a9",
                                                       "-C", "#bd93f9",
                                                       "--highd", "0.0",
                                                       "--lowd", "-64.0"] 10
                    , Run Cpu ["-t", "<fn=2>\xf108</fn> CPU: <total>%","-H","50","--high","red"] 20
                    , Run Memory ["-t", "<fn=2>\xf233</fn> MEM: <used>M"] 20
                    , Run DiskU [("/", "<fn=2>\xf0c7</fn> HDD: <free> free")] [] 60
                    , Run Date "<fn=2>\xf017</fn>  %H:%M  -  %b %d %Y " "date" 50
                    , Run Com ".config/xmobar/trayer-padding-icon.sh" [] "trayerpad" 20
                    , Run UnsafeStdinReader ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " %UnsafeStdinReader% }    <action=`kitty --hold -e jcal`>%date%</action>    { \
                    \ <box type=Bottom width=2 color=#bd93f9><fc=#bd93f9>%default:1:Master%</fc></box>   \
                    \ <box type=Bottom width=2 color=#f1fa8c><fc=#f1fa8c>%kbd-icon% %kbd%</fc></box>   \
                    \ <box type=Bottom width=2 color=#ff5555><fc=#ff5555><action=`kitty -e htop`>%cpu%</action></fc></box>   \
                    \ <box type=Bottom width=2 color=#5af78e><fc=#5af78e><action=`kitty -e htop`>%memory%</action></fc></box>   \
                    \ <box type=Bottom width=2 color=#ff79c6><fc=#ff79c6>%disku%</fc></box>   \
                    \ <box type=Bottom width=2 color=#caa9fa><fc=#caa9fa>%trayerpad%</fc></box>   "
       }

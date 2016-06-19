#!/usr/bin/osascript

global kColorValueMaximum
global activeApp

-- TODO: rewrite in a non-crazy language and just delegate the color-setting bits to AppleScript if really needed
-- TODO: base color on hash of current path
-- TODO: support argument to set random color instead
-- TODO: print/save colors, set prefs for certains paths, auto-set through .profile

on run (arguments)
	set kColorValueMaximum to 65535
    -- set activeApp to (path to frontmost application as Unicode text)
    -- set theTermApp to frontmost application
  set activeApp to ((path to frontmost application) as text)

  if (activeApp contains "Terminal.app") then
	  if ((count of arguments > 0) and ((first item of arguments) is equal to "all")) then
      tell application activeApp
        repeat with w in windows
          my colorifyTerminal(w)
        end repeat
      end tell
	  else
      tell application activeApp
        my colorifyTerminal(window 1)
      end tell
    end if
  else
    my colorifyIterm()
	end if
end run

on colorifyTerminal(|theWin|)
    tell application "Terminal"
        set {myBackgroundColor, myTextColor, myCursorColor} to my randomColors()

        set background color of |theWin| to myBackgroundColor
        set cursor color of |theWin| to myCursorColor
        set normal text color of |theWin| to myTextColor
        set bold text color of |theWin| to myTextColor
    end tell
end colorifyWindow

on colorifyIterm()
    tell application "iTerm2"
      tell current window
        tell current session
          set {myBackgroundColor, myTextColor, myCursorColor} to my randomColors()

          set background color to myBackgroundColor
          set foreground color to myTextColor
          set bold color to myTextColor
          set cursor color to myCursorColor
        end tell
      end tell
    end tell
end colorifyWindow

-- Largely inspired/copied from:

-- Copyright 2006, Red Sweater Software. All Rights Reserved.
-- Permission to copy granted for personal use only. All copies of this script
-- must retain this copyright information and all lines of comments below, up to
-- and including the line indicating "End of Red Sweater Comments".
--
-- Any commercial distribution of this code must be licensed from the Copyright
-- owner, Red Sweater Software.
--
-- This script alters the color of the frontmost Terminal window to be something random.
--
-- End of Red Sweater Comments
on randomColors()
	-- Choose a random color for the background
	set randomRed to (random number) * kColorValueMaximum
	set randomGreen to (random number) * kColorValueMaximum
	set randomBlue to (random number) * kColorValueMaximum
	set myBackgroundColor to {randomRed, randomGreen, randomBlue, -9000}
	
	-- Select appropriate text colors based on that background
	set {myTextColor, myCursorColor} to my ContrastingTextColors(myBackgroundColor)
	
	return {myBackgroundColor, myTextColor, myCursorColor}
end randomColors

on ContrastingTextColors(myColor)
	set whiteColor to {kColorValueMaximum, kColorValueMaximum, kColorValueMaximum, kColorValueMaximum}
	set lightGreyColor to {40000, 40000, 40000, kColorValueMaximum}
	set blackColor to {0, 0, 0, kColorValueMaximum}
	set darkGreyColor to {20000, 20000, 20000, kColorValueMaximum}
	
	-- From http://www.wilsonmar.com/1colors.htm
	set myRed to (item 1 of myColor) / kColorValueMaximum
	set myGreen to (item 2 of myColor) / kColorValueMaximum
	set myBlue to (item 3 of myColor) / kColorValueMaximum
	set magicY to (0.3 * myRed) + (0.59 * myGreen) + (0.11 * myBlue)
	if (magicY < 0.5) then
		return {whiteColor, lightGreyColor}
	else
		return {blackColor, darkGreyColor}
	end if
end ContrastingTextColors

-- Other iterm properties
--https://www.iterm2.com/documentation-scripting.html
--tell application iTerm2
--tell current window
--tell current session
--set foreground color to {65535, 0, 0, 0}
--set background color to {65535, 0, 0, 0}
--set bold color to {65535, 0, 0, 0}
--set cursor color to {65535, 0, 0, 0}
--set cursor text color to {65535, 0, 0, 0}
--set selected text color to {65535, 0, 0, 0}
--set selection color to {65535, 0, 0, 0}
--set background image to "/usr/share/httpd/icons/small/rainbow.png"
--set transparency to 0.5
--set name to "New Name"
--end tell
--end tell
--end tell


-- The name of the session's profile (different from the
-- session's name, which can be changed by editing the Session
-- Title field in Edit Session or by an escape sequence).
-- Added 10/6/15.
--write text (profile name)

-- is processing means it has received output in the last two seconds.
--if (is processing) then
--set foreground color to { 65535, 65535, 65535, 65535 }
--end if

-- This will only work if shell integration is installed.
-- Otherwise it always returns false.
--if (is at shell prompt) then
--set background color to { 65535, 0, 65535, 65535 }
--end if

-- New in 2.9.20160104
--set answerback string to "Hello world"

-- New in 2.9.201601. See https://iterm2.com/badges.html for more on variables.
--variable named "session.name"
--set variable named "user.phaseOfTheMoon" to "Gibbous"

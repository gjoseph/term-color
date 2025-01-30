This is a simple CLI tool that sets the background color of your OSX terminal (currently supports both Terminal.app and
iTerm).

This was initially based off https://red-sweater.com/blog/220/random-color-terminal, converted to Go, and now that it's
in a non-crazy language, I should be able to add the following features:

* save favorite colors, cycle through favorite colors (instead of being limited to new random ones)
* set to specified color (support hex)
* reset to black or system default
* better contrast algorithm?
* ban certain color ranges
* only allow colors that work with colored diff (and/or allow switching color scheme of e.g git diff? -- actually there is, see https://git-scm.com/docs/git-config --get-color```)
* set color based on hash of current host and/or directory
* save colors per directory
* running the tool in your PS1 (or in PROMPT_COMMAND) should let it automatically change the color if reaching a "saved" directory

* reset all windows/tabs in one go (possible in original AppleScript script and Terminal.app)
* support ANSI instead of (or in addition to) AppleScript - such that colors can be set on remote hosts too (and this script be more portable?)

Build:
------
Until a binary download is available, make sure you have Go and do this:
```
go get github.com/gjoseph/term-color
go install github.com/gjoseph/term-color
```

Kudos:
------
* https://github.com/everdev/mack hey I can do AppleScript in Go!
* https://red-sweater.com/blog/220/random-color-terminal the original script and idea

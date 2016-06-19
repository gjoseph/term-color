This is a simple CLI tool that sets the background color of your OSX terminal (currently supports both Terminal.app and
iTerm).

This was initially based off https://red-sweater.com/blog/220/random-color-terminal, converted to Go, and now that it's
in a non-crazy language, I should be able to add the following features:

* save favorite colors, cycle through favorite colors (instead of being limited to new random ones)
* set color based on hash of current directory
* save colors per directory
* running the tool in your PS1 (or in PROMPT_COMMAND) should let it automatically change the color if reaching a "saved" directory
* reset all windows/tabs in one go (possible in original AppleScript script and Terminal.app)

Build:
------
Until a binary download is available, make sure you have Go and do this:
```
go get bitbucket.org/hpesojg/term-color
go install bitbucket.org/hpesojg/term-color
```

Kudos:
------
* https://github.com/everdev/mack hey I can do AppleScript in Go!
* https://red-sweater.com/blog/220/random-color-terminal the original script and idea

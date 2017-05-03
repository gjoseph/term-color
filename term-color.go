package main

import (
    "fmt"
    "log"
    "math/rand"
    "time"
    "github.com/everdev/mack"
    "os"
)

type Color struct {
    // we dont really need image.color.RGBA
    r, g, b, a int
}

func (c Color) appleScriptColor() string {
    return fmt.Sprintf("{%d,%d,%d,%d}", c.r, c.g, c.b, c.a)
}

const (
    MAX = 65535
    DEFAULT_ALPHA = -9000
)

var WHITE = Color{65535, 65535, 65535, DEFAULT_ALPHA}
var LIGHT_GREY = Color{40000, 40000, 40000, DEFAULT_ALPHA}
var DARK_GREY = Color{20000, 20000, 20000, DEFAULT_ALPHA}
var BLACK = Color{0, 0, 0, DEFAULT_ALPHA}

func randomColor() Color {
    rnd := rand.New(rand.NewSource(time.Now().UnixNano()))
    r := rnd.Intn(MAX + 1)// because Intn's upper bound is exclusive
    g := rnd.Intn(MAX + 1)
    b := rnd.Intn(MAX + 1)
    a := DEFAULT_ALPHA
    return Color{r, g, b, a}
}

func contrast(c Color) Color {
    // http://www.wilsonmar.com/1colors.htm#ColorTheoryz says:
    // "A good rule of thumb is to take your background colour and compute Y = 0.3R + 0.59G + 0.11B. If Y exceeds 0.5, use black foreground text, otherwise use white."
    // So we'll roll with that rather than the more complex http://www.msfw.com/Services/ContrastRatioCalculator ?

    // i feel like i don't really know how to handle math in Go :D
    magic := float32((float32(float32(c.r) / MAX) * float32(0.3)) + (float32(float32(c.g) / MAX) * float32(0.59)) + (float32(float32(c.b) / MAX) * float32(0.11)))
    if (magic > 0.5) {
        return BLACK
    } else {
        return WHITE
    }
}

func cursorColor(bg Color, fg Color) Color {
    if (fg == BLACK) {
        return DARK_GREY
    } else {
        return LIGHT_GREY
    }
}

func iTermScript(bgColor Color, fgColor Color, boldColor Color, cursorColor Color) string {
    return fmt.Sprintf(
        `tell current window
                tell current session
                        set background color to %s
                        set foreground color to %s
                        set bold color to %s
                        set cursor color to %s
                  end tell
        end tell`,
        bgColor.appleScriptColor(), fgColor.appleScriptColor(), boldColor.appleScriptColor(), cursorColor.appleScriptColor())
}

func terminalScript(bgColor Color, fgColor Color, boldColor Color, cursorColor Color) string {
    return fmt.Sprintf(
        `set background color of window 1 to %s
         set cursor color of window 1 to %s
         set normal text color of window 1 to %s
         set bold text color of window 1 to %s`,
        bgColor.appleScriptColor(), fgColor.appleScriptColor(), boldColor.appleScriptColor(), cursorColor.appleScriptColor())
}

func main() {
    bgColor := randomColor()
    fgColor := contrast(bgColor)
    cursorColor := cursorColor(bgColor, fgColor)

    termProgram := os.Getenv("TERM_PROGRAM")
    var app string
    var commands func(bgColor, fgColor, boldColor, cursorColor Color) string
    switch termProgram {
    case `Apple_Terminal`:
        app = `Terminal`
        commands = terminalScript
    case `iTerm.app`:
        app = `iTerm2`
        commands = iTermScript
    default:
        if termProgram == `` {
            termProgram = `<undefined>`
        }
        log.Fatal("Unsupported terminal program: ", termProgram)
    }

    _, err := mack.Tell(app, commands(bgColor, fgColor, fgColor, cursorColor))
    if err != nil {
        log.Fatal(err)
    }
}


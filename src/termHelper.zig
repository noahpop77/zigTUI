const std = @import("std");
const macos = std.os.macos;

const posix = std.posix;

const c = @cImport({
    @cInclude("termios.h");
    @cInclude("unistd.h");
});

// Enables the terminal alternate screen for more freely drawing things using ANSII codes. 
// After we do our thing for drawing we turn it off with exitAliScreen()
pub fn enterAltScreen(writer: *std.Io.Writer) !void {
    try writer.print("\x1b[?1049h", .{});   // enable alt screen
    try writer.print("\x1b[2J", .{});       // clear
    try writer.print("\x1b[H", .{});        // move cursor home
    try writer.print("\x1b[?25l", .{});     // Hides the cursor
    try writer.flush();
}

pub fn exitAltScreen(writer: *std.Io.Writer) !void {
    try writer.print("\x1b[?25h", .{});     // Ansii code for Enables cursor
    try writer.print("\x1b[?1049l", .{});   // Ansii code for disable alt screen
    try writer.flush();
}


var orig_termios: c.struct_termios = undefined;

pub fn enableRawMode() !void {
    const fd: i32 = 0; // stdin
    if (c.tcgetattr(fd, &orig_termios) != 0) return error.Failed;

    var raw = orig_termios;

    // disable echo + canonical mode + signals
    raw.c_lflag &= ~(@as(u32, c.ECHO | c.ICANON | c.ISIG));

    // disable software flow control and CR->NL conversion
    raw.c_iflag &= ~(@as(u32, c.IXON | c.ICRNL));

    // disable post‑processing output
    raw.c_oflag &= ~(@as(u32, c.OPOST));

    // immediate character reads
    raw.c_cc[c.VMIN] = 1;
    raw.c_cc[c.VTIME] = 0;

    if (c.tcsetattr(fd, c.TCSAFLUSH, &raw) != 0) return error.Failed;
}

pub fn disableRawMode() !void {
    const fd: i32 = 0;
    _ = c.tcsetattr(fd, c.TCSAFLUSH, &orig_termios);
}
pub fn userIn() !void {
    try enableRawMode();
    defer disableRawMode() catch {};

    var buf: [1]u8 = undefined;
    var wrapper = std.fs.File.stdin().reader(&buf);
    const stdin: *std.Io.Reader = &wrapper.interface;

    // std.debug.print("Press 'q' to quit\n", .{});

    while (true) {
        const result = stdin.takeByte();
        if (result) |byte| {
            if (byte == 'q') {
                break; // exit immediately
            }
            // print non‑q keys if you want
            // std.debug.print("Got: {c}\n", .{byte});
        } else |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        }
    }
}



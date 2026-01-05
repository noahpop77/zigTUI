const std = @import("std");
const macos = std.os.macos;

const posix = std.posix;

const c = @cImport({
    @cInclude("termios.h");
    @cInclude("unistd.h");
});

pub fn enterAltScreen(writer: *std.Io.Writer) !void {
    try writer.print("\x1b[?1049h", .{}); // enable alt screen
    try writer.print("\x1b[2J", .{});     // clear
    try writer.print("\x1b[H", .{});      // move cursor home
    try writer.flush();
}

pub fn exitAltScreen(writer: *std.Io.Writer) !void {
    try writer.print("\x1b[?1049l", .{}); // disable alt screen
    try writer.flush();
}


const std = @import("std");
const box = @import("src/flexBox.zig");
const term = @import("src/termHelper.zig");

pub fn main() !void {
    var buf: [4096]u8 = undefined;
    var writer = std.fs.File.stdout().writer(&buf);
    const stdout = &writer.interface;


    try term.enterAltScreen(stdout);
    defer term.exitAltScreen(stdout) catch {};

    try box.printSquare(stdout);
    // try stdout.flush();
    
    try term.userIn();

}







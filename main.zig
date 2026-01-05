const std = @import("std");
const home = @import("src/homescreen.zig");
const term = @import("src/term.zig");

pub fn main() !void {
    var buf: [4096]u8 = undefined;
    var writer = std.fs.File.stdout().writer(&buf);
    const stdout = &writer.interface;

    try home.printSquare(stdout);

    try stdout.flush();
}



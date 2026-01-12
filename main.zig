const std = @import("std");
const box = @import("src/flexBox.zig");
const term = @import("src/termHelper.zig");

pub fn main() !void {
    var buf: [4096]u8 = undefined;
    var writer = std.fs.File.stdout().writer(&buf);
    const stdout = &writer.interface;

    try stdout.print("bob\n", .{});

    try box.printSquare(stdout);
    
    try stdout.print("BOBBY\n", .{});
    try stdout.flush();

}




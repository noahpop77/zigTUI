const std = @import("std");
const box = @import("src/flexBox.zig");
const term = @import("src/termHelper.zig");

pub fn main() !void {
    // My writer :)
    var buf: [4096]u8 = undefined;
    var writer = std.fs.File.stdout().writer(&buf);
    const stdout = &writer.interface;

    try stdout.print("bob\n", .{});

    try box.printSquare(stdout);
    
    try stdout.print("BOBBY\n", .{});
    try stdout.flush();
    
    // Format for sleeping for X amount of time
    // std.Thread.sleep(5 * std.time.ns_per_s);

}




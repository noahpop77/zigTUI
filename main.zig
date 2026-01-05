const std = @import("std");

pub fn createWriter(buf: []u8) std.fs.File.Writer {
    return std.fs.File.stdout().writer(buf);
}

pub fn main() !void {
    var buf: [4096]u8 = undefined;
    var writer = createWriter(&buf);
    const stdout = &writer.interface;


    try stdout.print("Hello buffered world!\n", .{});
    try stdout.print("Hello buffered world!\n", .{});
    try stdout.print("Hello buffered world!\n", .{});
    try stdout.flush();   // or writer.flush()
}



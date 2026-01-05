const std = @import("std");
const home = @import("homescreen.zig");
const term = @import("term.zig");

pub fn createWriter(buf: []u8) std.fs.File.Writer {
    return std.fs.File.stdout().writer(buf);
}

pub fn main() !void {
    var buf: [4096]u8 = undefined;
    var writer = createWriter(&buf);
    const stdout = &writer.interface;

    const size = (try  term.termSize(std.fs.File.stdout())).?;
    const termWidth: home.Range = home.getCenterWidth(size.width);

    try home.printHorizBar(termWidth, stdout);
    
    try stdout.flush();   // or writer.flush()
}



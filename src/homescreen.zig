const std = @import("std");

pub const Range = struct {
    start: u16,
    end: u16,
    length: u16,
};

pub fn getCenterWidth(width: u16) Range {
    const gap = width/2;
    const shift = width / 4;
    const rangeStart = shift;
    const rangeEnd = width + shift - gap;
    std.debug.print("Width: {d}\nGap: {d}\nRange: {d} to {d}\n", .{width, gap, rangeStart, rangeEnd});
    return Range{ .start = rangeStart, .end = rangeEnd, .length = gap};
}

fn writeRepeated( writer: *std.Io.Writer, ch: u8, count: usize,) !void {
    var buf: [256]u8 = undefined;

    var remaining = count;
    while (remaining > 0) {
        const n = @min(remaining, buf.len);
        @memset(buf[0..n], ch);
        try writer.writeAll(buf[0..n]);
        remaining -= n;
    }
}

pub fn printHorizBar(range: Range, writer: *std.Io.Writer) !void {
   try writeRepeated(writer, ' ', range.length/2);
   try writeRepeated(writer, '=', range.length);
   try writeRepeated(writer, ' ', range.length/2);
   try writer.print("\n", .{});
}


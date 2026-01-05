const std = @import("std");
const term = @import("term.zig");
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
    return Range{ .start = rangeStart, .end = rangeEnd, .length = gap};
}

pub fn getCenterHeight(height: u16) Range {
    const gap = height/2;
    const shift = height / 4;
    const rangeStart = shift;
    const rangeEnd = height + shift - gap;
    std.debug.print("Height: {d}\nGap: {d}\nRange: {d} to {d}\n", .{height, gap, rangeStart, rangeEnd});
    return Range{ .start = rangeStart, .end = rangeEnd, .length = gap};
}

fn writeRepeated(writer: *std.io.Writer, s: []const u8, count: usize) !void {
    for (0..count) |_| {
        try writer.writeAll(s);
    }
}

pub fn printSquare(stdout: *std.Io.Writer) !void {

    const size = (try  term.termSize(std.fs.File.stdout())).?;
    const termWidth: Range = getCenterWidth(size.width);
    const termHeight: Range = getCenterHeight(size.height);

    try printHorizBar(termWidth, stdout);
    try printSideBars(termWidth, termHeight, stdout);
    try printHorizBar(termWidth, stdout);
}

pub fn printSideBars(width: Range, height: Range ,writer: *std.Io.Writer) !void {
    for (0..height.length) |_| {
        try writeRepeated(writer, " ", (width.length/2) - 0);
        try writeRepeatedColoredHex(writer, "█", 0x531599, 1);
        try writeRepeatedColoredHex(writer, "█", 0x531599, 1);
        try writeRepeated(writer, " ", width.length - 4);
        try writeRepeatedColoredHex(writer, "█", 0x531599, 1);
        try writeRepeatedColoredHex(writer, "█", 0x531599, 1);
        try writeRepeated(writer, " ", (width.length/2)-1);
        try writer.print("\n", .{});
    }
}

pub fn printHorizBar(range: Range, writer: *std.Io.Writer) !void {
    try writeRepeated(writer, " ", range.length/2);
    try writeRepeatedColoredHex(writer, "█", 0x531599, range.length);
    try writeRepeated(writer, " ", range.length/2);
    try writer.print("\n", .{});
}

// WriteRepeatedColoredHex accepts a writer (usually something like below).
//     var buf: [4096]u8 = undefined;
//     var writer = std.fs.File.stdout().writer(&buf);
//     var writer = createWriter(&buf);
//     const stdout = &writer.interface;
//  inStr: accepts a string that will be repeated (usually a single character)
//  colorHex: Is the hex color code the characters will be. Usually in the format
//      of 0x{colorcode} Ex. 0x53159 to produce purple
//  count: Amount of times to repeat string
pub fn writeRepeatedColoredHex(
    writer: *std.io.Writer,
    inStr: []const u8,
    colorHex: u32,
    count: usize,
) !void {
    const reset = "\x1b[0m";

    const r = (colorHex >> 16) & 0xFF;
    const g = (colorHex >> 8) & 0xFF;
    const b = colorHex & 0xFF;

    var code: [32]u8 = undefined;
    const codeSlice = try std.fmt.bufPrint(&code, "\x1b[38;2;{d};{d};{d}m", .{r, g, b});

    try writer.writeAll(codeSlice);
    for (0..count) |_| {
        try writer.writeAll(inStr);
    }
    try writer.writeAll(reset);
}


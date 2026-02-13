const std = @import("std");
const Io = std.Io;

pub fn readLine(gpa: *std.heap.GeneralPurposeAllocator(.{}), stdin_buffer: []u8) ![]const u8 {

    const allocator = gpa.allocator();

    var init_io: Io.Threaded = .init(allocator, .{});
    defer init_io.deinit();
    const io = init_io.io();

    var init_reader: Io.File.Reader = .init(.stdin(), io, stdin_buffer);//error expected type []u8 found *const []u8
    var stdin = &init_reader.interface;

    const line = try stdin.takeDelimiterExclusive('\n');

    const trimmed = std.mem.trim(u8, line, " \t\r");
    const result = try allocator.dupe(u8, trimmed);
    return result;
}


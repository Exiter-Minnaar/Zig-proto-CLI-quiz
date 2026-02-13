const std = @import("std");
const Io = std.Io;

pub const Command = enum { exit, create, remove, ls, edit,get, none };

//This is the helper function for reading input and output.
pub fn readLine(gpa: *std.heap.GeneralPurposeAllocator(.{}), stdin_buffer: []u8) ![]const u8 {
    const allocator = gpa.allocator();

    var init_io: Io.Threaded = .init(allocator, .{});
    defer init_io.deinit();
    const io = init_io.io();

    var init_reader: Io.File.Reader = .init(.stdin(), io, stdin_buffer);
    var stdin = &init_reader.interface;

    const line = try stdin.takeDelimiterExclusive('\n');

    const trimmed = std.mem.trim(u8, line, " \t\r");
    const result = try allocator.dupe(u8, trimmed);
    return result;
}

pub fn toDo(message: []const u8) Io.Writer.Error!void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var thread: Io.Threaded = .init(allocator, .{});
    defer _ = thread.deinit();
    const io = thread.io();

    var buffer: [1024]u8 = undefined;
    var writer: Io.File.Writer = .init(.stdout(), io, &buffer);
    var stdout = &writer.interface;

    try stdout.print("To do: {s}\n", .{message});
    try stdout.flush();
}

pub fn matchCommand(command: *Command, match: []const u8) void {
    if (std.mem.eql(u8, match, "exit")) {
        command.* = Command.exit;
    } else if (std.mem.eql(u8, match, "create")) {
        command.* = Command.create;
    } else if (std.mem.eql(u8, match, "remove")) {
        command.* = Command.remove;
    } else if (std.mem.eql(u8, match, "ls")) {
        command.* = Command.ls;
    } else if (std.mem.eql(u8, match, "edit")) {
        command.* = Command.edit;
    } else if (std.mem.eql(u8, match, "get")) {
        command.* = Command.get;
    } else {
        command.* = Command.none;
    }
}

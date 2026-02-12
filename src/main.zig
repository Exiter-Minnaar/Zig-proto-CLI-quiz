const std = @import("std");
const Io = std.Io;
const dbPrint  = std.debug.print;
const root = @import("root.zig");

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{.safety = true}) = .init;
    defer {
        const leak = gpa.deinit();
        if (leak == .leak) {
            dbPrint("Warning: Memory leak detected!", .{});
        }
    }
    var buffer: [1024]u8 = undefined;

    while (true) {
        dbPrint("Password: ", .{});
        const line = try root.readLine(&gpa, &buffer);  
        defer gpa.allocator().free(line);
        if (std.mem.eql(u8, line, "Gt546(*&")) {
            dbPrint("\nAccess granted!\n", .{});
            break;
        } else {
            dbPrint("\nAccess denied!\n", .{});
        }
    }
}


Early proto typing.
const std = @import("std");
const Io = std.Io;
const dbPrint = std.debug.print;
const root = @import("root.zig");
const ArrayList = std.ArrayList;

const QuizCommands = enum { Ls, Create, Remove, Edit };
const Quiz = struct {
    allocator: std.mem.Allocator,
    names: ArrayList([]const u8),
    questions: ArrayList([]const u8),
    multiple_As: ArrayList([]const u8),
    multiple_Bs: ArrayList([]const u8),
    multiple_Cs: ArrayList([]const u8),
    multiple_Ds: ArrayList([]const u8),
    correctAwnsers: ArrayList([]u8),

    const Self = @This();
    fn init(allocator: std.mem.Allocator) !Self {
        return Self{
            .allocator = allocator,
            .names = ArrayList([]const u8).initCapacity(allocator, 1024),
            .questions = ArrayList([]const u8).initCapacity(allocator, 1024),
            .multiple_As = ArrayList([]const u8).initCapacity(allocator, 1024),
            .multiple_Bs = ArrayList([]const u8).initCapacity(allocator, 1024),
            .multiple_Cs = ArrayList([]const u8).initCapacity(allocator, 1024),
            .multiple_Ds = ArrayList([]const u8).initCapacity(allocator, 1024),
        };
    }

    fn run(self: Self) !void {
        dbPrint("Quiz--------parameters-----info\n", .{});
        dbPrint("commands:\n get <quiz name> gets a quiz.\n ls lists all quizes.\n create <quiz name>\n remove <quiz name>\n edit <quiz name> edit an existing quiz.");
        var buffer: [1024]u8 = undefined;
        const reader = root.readLine(self.allocator, &buffer);
        _ = reader;
    }
};
pub fn main() !void {
    var allocator = std.heap.page_allocator;
    defer _ = allocator.deinit();
    const quiz: Quiz = try Quiz.init(allocator);

    try quiz.names.append("Math Quiz");
    try quiz.questions.append("What is 2+2?");
    try quiz.multiple_As.append("3");
    try quiz.multiple_Bs.append("4");
    try quiz.correctAnswers.append('B');

    std.debug.print("Quiz created with {} questions\n", .{quiz.questions.items.len});
}
const std = @import("std");
const dbPrint = std.debug.print;
const ArrayList = std.ArrayList;
const root = @import("root.zig");

const Quiz = struct {
    names: ArrayList([]const u8),
    questions: ArrayList([]const u8),
    multiple_As: ArrayList([]const u8),
    multiple_Bs: ArrayList([]const u8),
    multiple_Cs: ArrayList([]const u8),
    multiple_Ds: ArrayList([]const u8),
    correctAnswers: ArrayList(u8),

    const Self = @This();

    pub fn run(self: *Self, gpa: *std.heap.GeneralPurposeAllocator(.{})) !void {
        _ = self;
        const allocator = gpa.allocator();
        dbPrint("Quiz--------parameters-----info\n", .{});
        dbPrint(
            "commands:\n get <quiz name> gets a quiz.\n ls lists all quizes.\n create <quiz name>\n remove <quiz name>\n edit <quiz name> edit an existing quiz.\n",
            .{},
        );
        var buffer: [1024]u8 = undefined;
        const reader = try root.readLine( gpa, &buffer);
        defer allocator.free(reader);
    }

    pub fn init(allocator: std.mem.Allocator) !Self {
        return Self{
            .names = try ArrayList([]const u8).initCapacity(allocator, 16),
            .questions = try ArrayList([]const u8).initCapacity(allocator, 16),
            .multiple_As = try ArrayList([]const u8).initCapacity(allocator, 16),
            .multiple_Bs = try ArrayList([]const u8).initCapacity(allocator, 16),
            .multiple_Cs = try ArrayList([]const u8).initCapacity(allocator, 16),
            .multiple_Ds = try ArrayList([]const u8).initCapacity(allocator, 16),
            .correctAnswers = try ArrayList(u8).initCapacity(allocator, 16),
        };
    }

    pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
        self.names.deinit(allocator);
        self.questions.deinit(allocator);
        self.multiple_As.deinit(allocator);
        self.multiple_Bs.deinit(allocator);
        self.multiple_Cs.deinit(allocator);
        self.multiple_Ds.deinit(allocator);
        self.correctAnswers.deinit(allocator);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var quiz = try Quiz.init(allocator);
    defer quiz.deinit(allocator);

    try quiz.names.append(allocator, "Math Quiz");
    try quiz.questions.append(allocator, "What is 2+2?");
    try quiz.multiple_As.append(allocator, "3");
    try quiz.multiple_Bs.append(allocator, "4");
    try quiz.correctAnswers.append(allocator, 'B');

    try quiz.run(&gpa); // pass the concrete allocator type
}
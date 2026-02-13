const std = @import("std");
const dbPrint = std.debug.print;
const ArrayList = std.ArrayList;
const root = @import("root.zig");


const commandError = error {
    invalidCommand
};

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
        dbPrint("              Quiz\ncommands-----parameters-----info\n", .{});
        dbPrint(
            " get <quiz name> gets a quiz.\n ls lists all quizes.\n create <quiz name>\n remove <quiz name>\n edit <quiz name> edit an existing quiz.\n exit exits the quiz.\n",
            .{},
        );
        const allocator = gpa.allocator();
        while (true) {
            var buffer: [1024]u8 = undefined;
            const reader = try root.readLine(gpa, &buffer);
            defer allocator.free(reader);
            var command:root.Command = root.Command.none;

            _ = root.matchCommand(&command, reader);

            try switch (command) {
                .create => root.toDo("Create a function that creates a new quiz."),
                .edit => root.toDo("Create a function that edits an exitsing quiz."),
                .ls => root.toDo("Create a function that lists all the availble quizes."),
                .remove => root.toDo("Create a function that removes an exitsting quiz."),
                .get => root.toDo("Create a function that gets a quiz."),
                .none => std.debug.print("{s}", .{"Unknown command!\n"}),
                .exit => break,
            };
        }
    }

    pub fn init(allocator: std.mem.Allocator) !Self {
        return Self{
            .names = try ArrayList([]const u8).initCapacity(allocator, 160),
            .questions = try ArrayList([]const u8).initCapacity(allocator, 160),
            .multiple_As = try ArrayList([]const u8).initCapacity(allocator, 160),
            .multiple_Bs = try ArrayList([]const u8).initCapacity(allocator, 160),
            .multiple_Cs = try ArrayList([]const u8).initCapacity(allocator, 160),
            .multiple_Ds = try ArrayList([]const u8).initCapacity(allocator, 160),
            .correctAnswers = try ArrayList(u8).initCapacity(allocator, 0o240), //octal for 160
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
    _ = try root.toDo("Add a function that handles commands!");

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


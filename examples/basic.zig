const zui = @import("zui");
const std = @import("std");
const print = std.debug.print;
const App = zui.App;
const BuildResult = zui.BuildResult;

usingnamespace zui.Elements;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

var state = struct {
    name: []const u8 = "test"
};

pub const Element = struct {
    tag: type,
    link: usize,
};

pub fn buildElement(link: anytype) Element {
    return Element{
        .tag = @TypeOf(link),
        .link = @ptrToInt(&link),
    };
}

pub fn main() !void {
    var app = App.new(allocator);
    var result = BuildResult.new(allocator);

    const rec = Rectangle.new(.{
        .width = 300,
        .height = 200,
    });

    const txt = Text.new(.{
        .width = 300,
        .height = 200,
        .text = "testing text",
    });

    const grid = Grid.new(.{
        .width = 300,
        .height = 200,
        .columns = 1,
        .rows = 3,
    }, allocator);
}

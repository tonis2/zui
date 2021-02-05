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

pub fn main() !void {
    var app = App.new(allocator);
    var result = BuildResult.new(allocator);

    const elements = .{
        .Rectangle = Rectangle,
        .Text = Text,
    };

    const rec = Rectangle.new(.{
        .width = 300,
        .height = 200,
    });

    const fields = @typeInfo(@TypeOf(elements)).Struct.fields;

    const txt = Text.new(.{
        .width = 10,
        .height = 20,
        .text = "testing text",
    });

    const grid = Grid.new(.{
        .width = 300,
        .height = 200,
        .columns = 1,
        .rows = 3,
    }, allocator).child(rec).child(txt);

    try grid.update(fields, &result);

    for (result.vertices.items) |res| {
        print(" vert  {} \n", .{res.position.x});
    }
}

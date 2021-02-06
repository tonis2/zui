const zui = @import("zui");
const std = @import("std");
const print = std.debug.print;
const App = zui.App;
const Child = zui.Child;
const BuildResult = zui.BuildResult;

usingnamespace zui.Elements;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

var state = .{ .name = "test" };

const app = App.new(.{
    .Rectangle = Rectangle,
    .Text = Text,
    .Grid = Grid,
});

pub fn main() !void {
    var result = BuildResult.new(allocator);

    const rec = Rectangle.new(.{
        .width = 300,
        .height = 200,
    });

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
    }, allocator).appendSlice(&[_]Child{
        Child.from(rec),
        Child.from(txt),
    });

    try grid.update(app, &state);
    try grid.render(app, &result);

    for (result.vertices.items) |res| {
        print(" vert  {} \n", .{res.position.x});
    }
}

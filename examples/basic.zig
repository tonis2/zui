const zui = @import("zui");
const std = @import("std");
const print = std.debug.print;
const App = zui.App;
const ChildElement = zui.ChildElement;
const BuildResult = zui.BuildResult;

usingnamespace zui.Elements;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

var state = .{ .name = "test" };

pub fn main() !void {
    const app = App.new(.{
        .Rectangle = Rectangle,
        .Text = Text,
    });
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
    }, allocator).appendSlice(&[_]ChildElement{
        ChildElement.from(rec),
        ChildElement.from(txt),
    });

    try grid.update(app, &state);
    try grid.render(app, &result);

    for (result.vertices.items) |res| {
        print(" vert  {} \n", .{res.position.x});
    }
}

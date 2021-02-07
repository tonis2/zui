const zui = @import("zui");
const std = @import("std");
const print = std.debug.print;
const App = zui.App;
const Child = zui.Child;
const Style = zui.Style;
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

    var grid = Grid.new(.{
        .style = .{ .width = 300, .height = 300 },
        .rows = .{ .auto = true, .gap = 5 },
        .columns = .{ .count = 3 },
    }, allocator);

    _ = grid.appendSlice(&[_]Grid.Child{Grid.Child.from(Rectangle.new(.{ .width = 300, .height = 300 }))});

    try grid.update(app, &state);
    try grid.render(app, &result);

    for (result.vertices.items) |res| {
        print(" vert  {} \n", .{res.position[0]});
    }

    defer {
        result.deinit();
        grid.deinit();
        _ = gpa.deinit();
    }
}

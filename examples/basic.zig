const zui = @import("zui");
const std = @import("std");
const vulkan = @import("vulkan");
const print = std.debug.print;
const App = zui.App;

const Style = zui.Style;
const BuildResult = zui.BuildResult;

usingnamespace zui.Elements;

const Child = Grid.Child;

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
        .width = 300,
        .height = 300,
    }, allocator);

    _ = grid.appendSlice(&[_]Child{Child.from(Rectangle{ .style = .{ .width = 300, .height = 300 } })});

    try grid.update(app, &state);
    try grid.render(app, &result);

    for (result.vertices.items) |res| {
        print(" vert  {d} \n", .{res.position[0]});
    }

    try vulkan.run();

    defer {
        result.deinit();
        grid.deinit();
        _ = gpa.deinit();
    }
}

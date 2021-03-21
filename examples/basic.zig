const zui = @import("zui");
const std = @import("std");
const print = std.debug.print;

const Style = zui.Style;

usingnamespace @import("./elements.zig");

const Child = Grid.Child;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

var state = .{ .name = "test" };

pub fn main() !void {
    var grid = Grid.new(.{
        .width = 300,
        .height = 300,
    }, allocator);

    _ = grid.appendSlice(&[_]Child{
        Child.from(Text{ .text = "xt1", .style = .{ .width = 300, .height = 300 } }),
        Child.from(Text{ .text = "s23", .style = .{ .width = 300, .height = 300 } }),
    });

    try grid.update(&state);

    // for (result.vertices.items) |res| {
    //     print(" vert  {d} \n", .{res.position[0]});
    // }

    defer {
        grid.deinit();
        _ = gpa.deinit();
    }
}

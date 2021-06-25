const zui = @import("zui");
const std = @import("std");
const print = std.debug.print;
const Style = zui.Style;

usingnamespace @import("zui").Elements;

pub const CustomElements = .{
    .Text = Text,
    .Grid = Grid,
};

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

var state = .{ .name = "test" };

fn changeState() void {}

pub fn main() !void {
    var grid = Grid.new(.{
        .width = 300,
        .height = 300,
    }, allocator);

    grid.append(Text{ .text = "xt1", .style = .{ .width = 300, .height = 300 } });

    grid.update(&state);

    defer {
        grid.deinit();
        _ = gpa.deinit();
    }
}

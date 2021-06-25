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

var state = .{ .name = "state" };

fn changeState() void {}

pub fn main() !void {
    defer std.debug.assert(!gpa.deinit());
    
    var grid = Grid.new(.{
        .width = 300,
        .height = 300,
    }, allocator);

    defer grid.deinit();

    grid.append(Text{ .text = "test1", .style = .{ .width = 300, .height = 300 } });
    grid.append(Text{ .text = "test2", .style = .{ .width = 300, .height = 300 } });
    grid.update(&state);
}

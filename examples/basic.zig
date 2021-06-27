const zui = @import("zui");
const std = @import("std");
const print = std.debug.print;
const DrawBuffer = zui.DrawBuffer;
const Style = zui.Style;

usingnamespace @import("zui").Elements;

pub const CustomElements = .{
    .Text = Text,
    .Grid = Grid,
};

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

const State = struct {
    name: []const u8,
};

var state = State{ .name = "hello" };

var App: zui.App = .{ .state = state, .width = 200.0, .height = 200.0 };

fn changeState(self: *Text) void {
    self.text = "test3";
    std.debug.print("{s} \n", .{"sss"});
}

pub fn main() !void {
    defer std.debug.assert(!gpa.deinit());

    var result = DrawBuffer.new(allocator);
    defer result.deinit();

    var grid = Grid.new(.{
        .width = 300,
        .height = 300,
    }, allocator);

    defer grid.deinit();

    grid.append(Text{ .text = "test1", .style = .{ .width = 300, .height = 300 }, .click = changeState });
    grid.append(Text{ .text = "test2", .style = .{ .width = 300, .height = 300 } });
    grid.update(&state);
    grid.render(&result);

    std.debug.print("{d} \n", .{result.vertices.items});
}

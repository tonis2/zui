const zui = @import("zui");
const std = @import("std");
const print = std.debug.print;
const DrawBuffer = zui.DrawBuffer;
const Element = zui.Element;

usingnamespace @import("zui").Elements;

pub const CustomElements = [2]Element{ Element.new("text", Text), Element.new("grid", Grid) };

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

const State = struct {
    name: []const u8,
};

var App: zui.App(State) = .{ .state = .{ .name = "test" }, .width = 200.0, .height = 200.0 };

fn changeState(self: *Text) void {
    self.text = "test updated";
    std.debug.print("{d} \n", .{App.width});
}

pub fn main() !void {
    defer std.debug.assert(!gpa.deinit());

    var result = DrawBuffer.new(allocator);
    defer result.deinit();

    var grid = Grid.new(.{
        .width = 300,
        .height = 300,
    }, allocator);

    var grid2 = Grid.new(.{
        .width = 600,
        .height = 600,
    }, allocator);

    defer grid.deinit();
    defer grid2.deinit();

    grid2.append(Text{ .text = "test3", .style = .{ .width = 300, .height = 300 } });
    grid.append(grid2);

    grid.append(Text{ .text = "test2", .style = .{ .width = 300, .height = 300 }, .click = changeState });
    grid.append(Text{ .text = "test1", .style = .{ .width = 300, .height = 300 } });

    grid.update(&App);
    grid.render(&result);
}

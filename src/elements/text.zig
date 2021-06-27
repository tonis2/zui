const std = @import("std");
const Vertex = @import("../math.zig").Vertex;
const Style = @import("../style.zig");
const DrawBuffer = @import("../drawing.zig").DrawBuffer;
const print = std.debug.print;
const App = @import("../app.zig").App;

pub const Text = struct {
    style: Style,
    text: []const u8,
    click: ?fn (self: *Text) void = null,

    pub fn new(style: Style, text: []const u8) Text {
        return Text{
            .style = style,
            .text = text,
        };
    }

    pub fn update(self: *Text, state: anytype) void {
        print(" {s} \n", .{state.name});
        print(" {s} \n", .{self.text});
    }

    pub fn render(self: *Text, result: *DrawBuffer) void {
        result.drawRectangle(0, 100, 300, 300, .{ 1.0, 1.0, 1.0, 1.0 }) catch {};
    }
};

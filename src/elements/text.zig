const std = @import("std");
const Vertex = @import("../math.zig").Vertex;
const Style = @import("../style.zig");
const DrawBuffer = @import("../drawing.zig").DrawBuffer;
const print = std.debug.print;

const Self = @This();

style: Style,
text: []const u8,
click: ?fn (self: *Self) void = null,

pub fn new(style: Style, text: []const u8) Self {
    return Self{
        .style = style,
        .text = text,
    };
}

pub fn update(self: *Self, app: anytype) void {
    print(" {s} \n", .{self.text});
}

pub fn render(self: *Self, result: *DrawBuffer) void {
    result.drawRectangle(0, 100, 300, 300, .{ 1.0, 1.0, 1.0, 1.0 }) catch {};
}

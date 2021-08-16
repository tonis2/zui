const std = @import("std");
const Layout = @import("../layout.zig");
const DrawBuffer = @import("../drawing.zig").DrawBuffer;
usingnamespace @import("../meta.zig");
const print = std.debug.print;

const Self = @This();

layout: Layout,
text: []const u8,
click: ?fn (self: *Self) void = null,

pub fn new(layout: Layout, text: []const u8) Self {
    return Self{
        .layout = layout,
        .text = text,
    };
}

pub fn update(self: *Self, app: anytype) void {
    _ = app;
    print(" {s} \n", .{self.text});
}

pub fn render(self: *Self, result: *DrawBuffer) void {
    _ = self;
    result.drawRectangle(0, 100, 300, 300, Vec4.new(1.0, 1.0, 1.0, 1.0)) catch {};
}

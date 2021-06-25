const std = @import("std");
const Vertex = @import("../math.zig").Vertex;
const Style = @import("../style.zig").Style;
const print = std.debug.print;

pub const Text = struct {
    style: Style,
    text: []const u8,

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
    pub fn render(self: *Text, result: *BuildResult) void {}
};

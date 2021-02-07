const std = @import("std");
const App = @import("../app.zig").App;
const BuildResult = @import("../app.zig").BuildResult;
const Primitives = @import("../primitives.zig");
const Style = @import("../style.zig").Style;
const print = std.debug.print;

pub const Text = struct {
    style: Style,
    text: []const u8,

    pub fn new(style: Style, text: []const u8) Text {
        return Text{
            .style = style,
            .text = data.text,
        };
    }

    pub fn init(self: *Text, comptime app: App, state: anytype) !void {}
    pub fn update(self: *Text, comptime app: App, state: anytype) !void {
        print("state {} \n", .{state.name});
    }

    pub fn render(self: *Text, comptime app: App, result: *BuildResult) !void {
        try result.add(Primitives.Rectangle.new(.{
            .width = self.style.width,
            .height = self.style.height,
            .x = self.style.x,
            .y = self.style.y,
        }, self.style.background.value()));
    }
};

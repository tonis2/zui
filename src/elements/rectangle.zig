const std = @import("std");
const App = @import("../app.zig").App;
const Style = @import("../style.zig").Style;
const BuildResult = @import("../app.zig").BuildResult;
const Primitives = @import("../primitives.zig");

pub const Rectangle = struct {
    style: Style,

    pub fn new(style: Style) Rectangle {
        return Rectangle{
            .style = style,
        };
    }
    pub fn init(self: *Rectangle, comptime app: App, state: anytype) !void {}
    pub fn update(self: *Rectangle, comptime app: App, state: anytype) !void {}

    pub fn render(self: *Rectangle, comptime app: App, result: *BuildResult) !void {
        try Primitives.Rectangle.build(
            .{
                .width = self.style.width,
                .height = self.style.height,
                .x = self.style.x,
                .y = self.style.y,
            },
            self.style.background.value(),
            result,
        );
    }
};

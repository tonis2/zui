const std = @import("std");
const App = @import("../app.zig").App;
const Style = @import("../style.zig").Style;
const BuildResult = @import("../app.zig").BuildResult;
const Vertex = @import("../math.zig").Vertex;

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
        try result.add(
            .{
                .vertices = &[_]Vertex{
                    Vertex{ .position = [3]u32{ self.style.x, self.style.y, self.style.z }, .color = self.style.background.value() },
                    Vertex{ .position = [3]u32{ self.style.x + self.style.width, self.style.y, self.style.z }, .color = self.style.background.value() },
                    Vertex{ .position = [3]u32{ self.style.x + self.style.width, self.style.y + self.style.height, self.style.z }, .color = self.style.background.value() },
                    Vertex{ .position = [3]u32{ self.style.x, self.style.y + self.style.height, self.style.z }, .color = self.style.background.value() },
                },
                .indices = &[_]u16{ 0, 1, 2, 2, 3, 0 },
            }
        );
    }
};

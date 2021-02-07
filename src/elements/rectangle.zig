const std = @import("std");
const App = @import("../app.zig").App;
const Style = @import("../style.zig").Style;
usingnamespace @import("../math.zig");

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
        try result.add(MeshData{
            .vertices = &[_]Vertex{
                Vertex{ .position = Vec3.new(self.style.x, self.style.y, 0), .color = [4]u16{ 1.0, 1.0, 1.0, 1.0 } },
                Vertex{ .position = Vec3.new(self.style.x + self.style.width, self.style.y, 0), .color = [4]u16{ 1.0, 1.0, 1.0, 1.0 } },
                Vertex{ .position = Vec3.new(self.style.x + self.style.width, self.style.y + self.style.height, 0), .color = [4]u16{ 1.0, 1.0, 1.0, 1.0 } },
                Vertex{ .position = Vec3.new(self.style.x, self.style.y + self.style.height, 0), .color = [4]u16{ 1.0, 1.0, 1.0, 1.0 } },
            },
            .indices = &[_]u16{ 0, 1, 2, 2, 3, 0 },
        });
    }
};

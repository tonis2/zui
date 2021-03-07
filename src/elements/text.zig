const std = @import("std");
const App = @import("../app.zig").App;
const BuildResult = @import("../app.zig").BuildResult;
const Vertex = @import("../math.zig").Vertex;
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
       
    }

    pub fn render(self: *Text, comptime app: App, result: *BuildResult) !void {
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

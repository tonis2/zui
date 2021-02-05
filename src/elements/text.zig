const std = @import("std");
usingnamespace @import("../math.zig");

const parseInt = std.fmt.parseInt;
const print = std.debug.print;

pub const Text = struct {
    width: u32,
    height: u32,
    x: u32,
    y: u32,
    text: []const u8,

    pub fn new(data: struct { width: u32 = 0, height: u32 = 0, x: u32 = 0, y: u32 = 0, text: []const u8 }) Text {
        return Text{
            .width = data.width,
            .height = data.height,
            .x = data.x,
            .y = data.y,
            .text = data.text,
        };
    }

    pub fn update(self: *Text, state: anytype) !void {}

    pub fn render(self: *Text, result: *BuildResult) !void {
        print("text {} \n", .{self.text});
        try result.add(MeshData{
            .vertices = &[_]Vertex{
                Vertex{ .position = Vec3.new(self.x, self.y, 0), .color = [4]u16{ 1.0, 1.0, 1.0, 1.0 } },
                Vertex{ .position = Vec3.new(self.x + self.width, self.y, 0), .color = [4]u16{ 1.0, 1.0, 1.0, 1.0 } },
                Vertex{ .position = Vec3.new(self.x + self.width, self.y + self.height, 0), .color = [4]u16{ 1.0, 1.0, 1.0, 1.0 } },
                Vertex{ .position = Vec3.new(self.x, self.y + self.height, 0), .color = [4]u16{ 1.0, 1.0, 1.0, 1.0 } },
            },
            .indices = &[_]u16{ 0, 1, 2, 2, 3, 0 },
        });
    }
};

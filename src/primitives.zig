usingnamespace @import("./math.zig");

pub const Rectangle = struct {
    pub fn new(config: struct { x: u32, y: u32, z: u32 = 0, width: u32, height: u32 }, color: [4]u8) MeshData {
        return .{
            .vertices = &[_]Vertex{
                Vertex{ .position = [3]u32{ config.x, config.y, config.z }, .color = color },
                Vertex{ .position = [3]u32{ config.x + config.width, config.y, config.z }, .color = color },
                Vertex{ .position = [3]u32{ config.x + config.width, config.y + config.height, config.z }, .color = color },
                Vertex{ .position = [3]u32{ config.x, config.y + config.height, config.z }, .color = color },
            },
            .indices = &[_]u16{ 0, 1, 2, 2, 3, 0 },
        };
    }
};

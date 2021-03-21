const Vertex = @import("./math.zig").Vertex;

pub const Rectangle = struct {
    vertices: [4]Vertex,
    indices: [6]u16,

    fn new(x: u32, y: u32, width: u32, height: u32, color: [4]u8) Rectangle {
        return Rectangle{ .vertices = [4]Vertex{
            Vertex{ .position = [3]u32{ x, y, 1.0 }, .color = color },
            Vertex{ .position = [3]u32{ x + width, y, 1.0 }, .color = color },
            Vertex{ .position = [3]u32{ x + width, y + height, 1.0 }, .color = color },
            Vertex{ .position = [3]u32{ x, y + height, 1.0 }, .color = color },
        }, .indices = [6]u16{ 0, 1, 2, 2, 3, 0 } };
    }
};

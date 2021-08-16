const std = @import("std");
const Allocator = std.mem.Allocator;
usingnamespace @import("./meta.zig");

pub const MeshData = struct { indices: []const u16, vertices: []const Vertex };

pub const DrawBuffer = struct {
    vertices: std.ArrayList(Vertex),
    indices: std.ArrayList(u16),

    pub fn new(allocator: *Allocator) DrawBuffer {
        return DrawBuffer{
            .vertices = std.ArrayList(Vertex).init(allocator),
            .indices = std.ArrayList(u16).init(allocator),
        };
    }

    pub fn add(self: *DrawBuffer, data: MeshData) !void {
        for (data.indices) |value| {
            try self.indices.append(value + @intCast(u16, self.indices.items.len));
        }

        for (data.vertices) |vert| try self.vertices.append(vert);
    }

    pub fn drawRectangle(self: *DrawBuffer, x: f32, y: f32, width: f32, height: f32, color: Vec4) !void {
        const indices = [6]u16{ 0, 1, 2, 2, 3, 0 };

        try self.vertices.append(Vertex{ .position = Vec3.new(x, y, 1.0), .color = color });
        try self.vertices.append(Vertex{ .position = Vec3.new(x + width, y, 1.0), .color = color });
        try self.vertices.append(Vertex{ .position = Vec3.new(x + width, y + height, 1.0), .color = color });
        try self.vertices.append(Vertex{ .position = Vec3.new(x, y + height, 1.0), .color = color });

        for (indices) |value| {
            try self.indices.append(value + @intCast(u16, self.indices.items.len));
        }
    }

    pub fn clear(self: *DrawBuffer) void {
        self.vertices.shrink(0);
        self.indices.shrink(0);
    }

    pub fn deinit(self: *DrawBuffer) void {
        self.vertices.deinit();
        self.indices.deinit();
    }
};

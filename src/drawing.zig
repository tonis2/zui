const std = @import("std");
const Allocator = std.mem.Allocator;

usingnamespace @import("zalgebra");
usingnamespace @import("./meta.zig");

pub const MeshData = struct { indices: []const u16, vertices: []const Vertex };

const Range = struct {
    from: usize,
    to: usize,
};

const DrawGroup = struct { shader: u32 = 0, clip: f32, zIndex: f32, vertices: Range, indices: Range };

pub const DrawBuffer = struct {
    vertices: std.ArrayList(Vertex),
    indices: std.ArrayList(u16),
    drawGroups: std.ArrayList(DrawGroup),

    pub fn new(allocator: *Allocator) DrawBuffer {
        return DrawBuffer{
            .vertices = std.ArrayList(Vertex).init(allocator),
            .indices = std.ArrayList(u16).init(allocator),
            .drawGroups = std.ArrayList(DrawGroup).init(allocator),
        };
    }

    pub fn add(self: *DrawBuffer, data: MeshData) !void {
        for (data.indices) |value| {
            try self.indices.append(value + @intCast(u16, self.indices.items.len));
        }

        for (data.vertices) |vert| try self.vertices.append(vert);
    }

    pub fn drawRectangle(self: *DrawBuffer, x: f32, width: f32, y: f32, height: f32, color: Vec4) !void {
        const vertices_len = @intCast(u16, self.vertices.items.len);

        const indices = [6]u16{ 0 + vertices_len, 1 + vertices_len, 2 + vertices_len, 2 + vertices_len, 3 + vertices_len, 0 + vertices_len };
        const vertices = [4]Vertex{ Vertex{ .pos = Vec3.new(x, y, 1.0), .color = color }, Vertex{ .pos = Vec3.new(x + width, y, 1.0), .color = color }, Vertex{ .pos = Vec3.new(x + width, y + height, 1.0), .color = color }, Vertex{ .pos = Vec3.new(x, y + height, 1.0), .color = color } };

        try self.vertices.appendSlice(&vertices);
        try self.indices.appendSlice(&indices);
        try self.drawGroups.append(DrawGroup{ .clip = 0, .zIndex = 1, .vertices = .{ .from = self.vertices.items.len - 4, .to = self.vertices.items.len }, .indices = .{ .from = self.indices.items.len - 4, .to = self.indices.items.len } });
    }

    pub fn clear(self: *DrawBuffer) void {
        self.vertices.shrink(0);
        self.indices.shrink(0);
        self.drawGroups.shrink(0);
    }

    pub fn deinit(self: *DrawBuffer) void {
        self.vertices.deinit();
        self.indices.deinit();
        self.drawGroups.deinit();
    }
};

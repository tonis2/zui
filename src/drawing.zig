const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;
const TypeInfo = std.builtin.TypeInfo;

const Vertex = @import("./math.zig").Vertex;
const MeshData = @import("./math.zig").MeshData;

pub const DrawBuffer = struct {
    vertices: std.ArrayList(Vertex),
    indices: std.ArrayList(u16),

    pub fn new(allocator: *Allocator) DrawBuffer {
        return BuildResult{
            .vertices = std.ArrayList(Vertex).init(allocator),
            .indices = std.ArrayList(u16).init(allocator),
        };
    }

    pub fn add(self: *DrawBuffer, data: MeshData) !void {
        for (data.indices) |value| {
            try self.indices.append(value + @intCast(u16, self.indices.items.len));
        }

        for (data.vertices) |vert| {
            try self.vertices.append(vert);
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

const DrawCommand = struct {
    vertices: []const Vertex,
    indices: []const u16,
    shader: []const u8,
};

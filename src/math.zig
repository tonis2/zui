const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub const Vec3 = packed struct {
    x: u32,
    y: u32,
    z: u32,

    pub fn new(x: u32, y: u32, z: u32) Vec3 {
        return Vec3{
            .x = x,
            .y = y,
            .z = z,
        };
    }
};

pub const Vertex = struct {
    position: Vec3, color: [4]u16
};

pub const MeshData = struct {
    indices: []const u16, vertices: []const Vertex
};

pub const BuildResult = struct {
    vertices: std.ArrayList(Vertex),
    indices: std.ArrayList(u16),

    pub fn new(allocator: *Allocator) BuildResult {
        return BuildResult{
            .vertices = std.ArrayList(Vertex).init(allocator),
            .indices = std.ArrayList(u16).init(allocator),
        };
    }

    pub fn add(self: *BuildResult, data: MeshData) !void {
        for (data.indices) |value| {
            try self.indices.append(value + @intCast(u16, self.indices.items.len));
        }

        for (data.vertices) |vert| {
            try self.vertices.append(vert);
        }
    }

    pub fn clear(self: *BuildResult) void {
        self.vertices.shrink(0);
        self.indices.shrink(0);
    }

    pub fn deinit(self: *BuildResult) void {
        self.vertices.deinit();
        self.indices.deinit();
    }
};

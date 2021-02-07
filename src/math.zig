const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub const Vertex = struct {
    position: [3]u32, color: [4]u8
};

pub const MeshData = struct {
    indices: []const u16, vertices: []const Vertex
};

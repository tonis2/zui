const std = @import("std");
const Allocator = std.mem.Allocator;

usingnamespace @import("zalgebra");
usingnamespace @import("./meta.zig");

const Range = struct {
    from: usize,
    to: usize,
};

const DrawSettings = struct {
    shader: u32 = 0,
    clip: f32 = 0.0,
    zIndex: f32 = 0,
};

const DrawCall = struct { shader: u32 = 0, clip: f32 = 0.0, zIndex: f32 = 0, vertices: Range, indices: Range };

// fn compare(first: anytype, second: anytype) bool {
//     if (first.shader > second.shader) return true;
//     return false;
// }

pub const DrawBuffer = struct {
    vertices: std.ArrayList(Vertex),
    indices: std.ArrayList(u16),
    draws: std.ArrayList(DrawCall),

    pub fn new(allocator: *Allocator) DrawBuffer {
        return DrawBuffer{
            .vertices = std.ArrayList(Vertex).init(allocator),
            .indices = std.ArrayList(u16).init(allocator),
            .draws = std.ArrayList(DrawCall).init(allocator),
        };
    }

    pub fn drawRectangle(self: *DrawBuffer, x: f32, width: f32, y: f32, height: f32, color: Vec4, settings: DrawSettings) !u32 {
        const vertices_len = @intCast(u16, self.vertices.items.len);
        const indices = [6]u16{ 0 + vertices_len, 1 + vertices_len, 2 + vertices_len, 2 + vertices_len, 3 + vertices_len, 0 + vertices_len };
        const vertices = [4]Vertex{ Vertex{ .pos = Vec3.new(x, y, 1.0), .color = color }, Vertex{ .pos = Vec3.new(x + width, y, 1.0), .color = color }, Vertex{ .pos = Vec3.new(x + width, y + height, 1.0), .color = color }, Vertex{ .pos = Vec3.new(x, y + height, 1.0), .color = color } };

        try self.vertices.appendSlice(&vertices);
        try self.indices.appendSlice(&indices);
        try self.draws.append(DrawCall{ .shader = settings.shader, .clip = settings.clip, .zIndex = settings.zIndex, .vertices = .{ .from = self.vertices.items.len - 4, .to = self.vertices.items.len }, .indices = .{ .from = self.indices.items.len - 4, .to = self.indices.items.len } });
        return @intCast(u32, self.draws.items.len);
    }

    pub fn removeDraw(self: *DrawBuffer, index: u32) !void {
        const drawCall = self.draws.items[index];
        for (self.vertices.items[drawCall.vertices.from..drawCall.vertices.to]) |*vert| vert.into_zero();
    }

    pub fn clear(self: *DrawBuffer) void {
        self.vertices.clearAndFree();
        self.indices.clearAndFree();
        self.draws.clearAndFree();
    }

    pub fn deinit(self: *DrawBuffer) void {
        self.vertices.deinit();
        self.indices.deinit();
        self.draws.deinit();
    }

    // pub fn build(self: *DrawBuffer) void {
    //     bubbleSort(DrawCall, &self.draws, compare);
    // }
};

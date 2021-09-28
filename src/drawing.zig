const std = @import("std");
const Allocator = std.mem.Allocator;

usingnamespace @import("zalgebra");
usingnamespace @import("primitives.zig");
usingnamespace @import("meta.zig");

const DrawCategoryTag = enum {
    Rectangle,
    Triangle,
    Circle,
    Line,
    Text,
};

pub const DrawCategory = union(DrawCategoryTag) {
    Rectangle: Rectangle,
    Triangle: Rectangle,
    Circle: Circle,
    Line,
    Text,
};

pub const DrawList = struct {
    categories: std.ArrayList(DrawCategory),

    pub fn init(allocator: *Allocator) DrawList {
        return DrawList{ .categories = std.ArrayList(DrawCategory).init(allocator) };
    }

    pub fn draw(self: *DrawList, category: DrawCategory) !void {
        try self.categories.append(category);
    }

    pub fn clear(self: *DrawList) void {
        self.categories.clearAndFree();
    }

    pub fn deinit(self: *DrawList) void {
        self.categories.deinit();
    }

    pub fn build(self: DrawList, allocator: *Allocator) !DrawBuffer {
        var drawBuffer = DrawBuffer.new(allocator);

        for (self.categories.items) |item| {
            switch (item) {
                .Rectangle => |data| {
                    try drawBuffer.drawRectangle(data.x, data.width, data.y, data.height, data.color.raw());
                },
                .Triangle => |data| {
                    try drawBuffer.drawTriangle(data.x, data.width, data.y, data.height, data.color.raw());
                },
                .Circle => {},
                .Line => {},
                .Text => {},
            }
        }
        return drawBuffer;
    }
};

// bubbleSort(DrawCall, &self.draws, compare);

// fn compare(first: anytype, second: anytype) bool {
//     if (first.shader > second.shader) return true;
//     return false;
// }

pub const DrawBuffer = struct {
    vertices: std.ArrayList(Vertex),
    indices: std.ArrayList(u16),

    pub fn new(allocator: *Allocator) DrawBuffer {
        return DrawBuffer{
            .vertices = std.ArrayList(Vertex).init(allocator),
            .indices = std.ArrayList(u16).init(allocator),
        };
    }

    pub fn drawRectangle(self: *DrawBuffer, x: f32, width: f32, y: f32, height: f32, color: [4]f32) !void {
        const vertices_len = @intCast(u16, self.vertices.items.len);
        const indices = [6]u16{ 0 + vertices_len, 1 + vertices_len, 2 + vertices_len, 2 + vertices_len, 3 + vertices_len, 0 + vertices_len };
        const vertices = [4]Vertex{ Vertex{ .pos = Vec3.new(x, y, 0.0), .color = color }, Vertex{ .pos = Vec3.new(x + width, y, 0.0), .color = color }, Vertex{ .pos = Vec3.new(x + width, y + height, 0.0), .color = color }, Vertex{ .pos = Vec3.new(x, y + height, 0.0), .color = color } };

        try self.vertices.appendSlice(&vertices);
        try self.indices.appendSlice(&indices);
    }

    pub fn drawTriangle(self: *DrawBuffer, x: f32, width: f32, y: f32, height: f32, color: [4]f32) !void {
        const vertices_len = @intCast(u16, self.vertices.items.len);
        const vertices = [3]Vertex{ Vertex{ .pos = Vec3.new(x, y, 0.0), .color = color }, Vertex{ .pos = Vec3.new(x + width, y, 0.0), .color = color }, Vertex{ .pos = Vec3.new(x + width, y + height, 0.0), .color = color } };
        const indices = [3]u16{ 0 + vertices_len, 1 + vertices_len, 2 + vertices_len };
        try self.vertices.appendSlice(&vertices);
        try self.indices.appendSlice(&indices);
    }

    pub fn clear(self: *DrawBuffer) void {
        self.vertices.clearAndFree();
        self.indices.clearAndFree();
    }

    pub fn deinit(self: *DrawBuffer) void {
        self.vertices.deinit();
        self.indices.deinit();
    }
};

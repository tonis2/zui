const std = @import("std");
const Layout = @import("layout.zig");
const Allocator = std.mem.Allocator;

usingnamespace @import("zalgebra");
usingnamespace @import("./meta.zig");

pub const DrawCategory = enum {
    Rectangle,
    Triangle,
    Circle,
    Line,
    Text,
};

const DrawItem = struct {
    layout: u32,
    category: DrawCategory,
};

pub const DrawList = struct {
    categories: std.ArrayList(DrawItem),
    layouts: std.ArrayList(Layout),

    pub fn init(allocator: *Allocator) DrawList {
        return DrawList{ .categories = std.ArrayList(DrawItem).init(allocator), .layouts = std.ArrayList(Layout).init(allocator) };
    }

    pub fn draw(self: *DrawList, category: DrawCategory, layout: Layout) !void {
        try self.layouts.append(layout);
        try self.categories.append(DrawItem{ .layout = @intCast(u32, self.layouts.items.len - 1), .category = category });
    }

    pub fn clear(self: *DrawList) void {
        self.categories.clearAndFree();
        self.layouts.clearAndFree();
    }

    pub fn deinit(self: *DrawList) void {
        self.categories.deinit();
        self.layouts.deinit();
    }

    pub fn build(self: DrawList, allocator: *Allocator) !DrawBuffer {
        var drawBuffer = DrawBuffer.new(allocator);

        for (self.categories.items) |item| {
            const layout: Layout = self.layouts.items[item.layout];
            switch (item.category) {
                .Rectangle => {
                    try drawBuffer.drawRectangle(layout.x, layout.width, layout.y, layout.height, layout.background.raw());
                },
                .Triangle => {
                    try drawBuffer.drawTriangle(layout.x, layout.width, layout.y, layout.height, layout.background.raw());
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

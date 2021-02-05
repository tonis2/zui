const std = @import("std");
usingnamespace @import("../math.zig");
const Allocator = std.mem.Allocator;

pub const Element = struct {
    tag: type,
    ptr: usize,
};

pub const Grid = struct {
    width: u32,
    height: u32,
    x: u32,
    y: u32,
    columns: u32,
    rows: u32,

    pub fn new(data: struct { width: u32 = 0, height: u32 = 0, x: u32 = 0, y: u32 = 0, columns: u32, rows: u32 }, allocator: *Allocator) Grid {
        return Grid{
            .width = data.width,
            .height = data.height,
            .x = data.x,
            .y = data.y,
            .columns = data.columns,
            .rows = data.rows,
        };
    }

    // pub fn add_child(self: *Grid, element: anytype) !void {
    //     try self.children.append(Element{
    //         .tag = @TypeOf(element),
    //         .prt = @ptrToInt(&element),
    //     });
    // }

    pub fn update(self: *Grid, state: anytype) !void {}

    pub fn render(self: *Grid, result: *BuildResult) !void {
        try result.add(MeshData{
            .vertices = &[_]Vertex{
                Vertex{ .position = Vec3.new(self.x, self.y, 0), .color = [4]u16{ 1.0, 1.0, 1.0, 1.0 } },
                Vertex{ .position = Vec3.new(self.x + self.width, self.y, 0), .color = [4]u16{ 1.0, 1.0, 1.0, 1.0 } },
                Vertex{ .position = Vec3.new(self.x + self.width, self.y + self.height, 0), .color = [4]u16{ 1.0, 1.0, 1.0, 1.0 } },
                Vertex{ .position = Vec3.new(self.x, self.y + self.height, 0), .color = [4]u16{ 1.0, 1.0, 1.0, 1.0 } },
            },
            .indices = &[_]u16{ 0, 1, 2, 2, 3, 0 },
        });
    }
};

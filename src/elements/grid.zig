const std = @import("std");
usingnamespace @import("../math.zig");
const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub const Element = struct {
    name: []const u8,
    ptr: usize,
};

pub const Grid = struct {
    width: u32,
    height: u32,
    x: u32,
    y: u32,
    columns: u32,
    rows: u32,
    children: std.ArrayList(Element),

    pub fn new(data: struct { width: u32 = 0, height: u32 = 0, x: u32 = 0, y: u32 = 0, columns: u32, rows: u32 }, allocator: *Allocator) Grid {
        return Grid{
            .width = data.width,
            .height = data.height,
            .x = data.x,
            .y = data.y,
            .columns = data.columns,
            .rows = data.rows,
            .children = std.ArrayList(Element).init(allocator),
        };
    }

    pub fn child(self: *Grid, element: anytype) *Grid {
        self.children.append(Element{
            .name = @typeName(@TypeOf(element)),
            .ptr = @ptrToInt(&element),
        }) catch unreachable;
        return self;
    }

    pub fn update(self: *Grid, fields: anytype, result: *BuildResult) !void {
        for (self.children.items) |item| {
            inline for (fields) |field| {
                if (std.mem.eql(u8, field.name, item.name)) {
                    var data = @intToPtr(*field.default_value.?, item.ptr);
                    try data.render(result);
                }
            }
        }
    }

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

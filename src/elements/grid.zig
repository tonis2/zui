const std = @import("std");
const App = @import("../app.zig").App;
const Allocator = std.mem.Allocator;
const print = std.debug.print;

usingnamespace @import("../math.zig");

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

    pub fn append(self: *Grid, element: anytype) *Grid {
        self.children.append(Element{
            .name = @typeName(@TypeOf(element)),
            .ptr = @ptrToInt(&element),
        }) catch unreachable;
        return self;
    }

    pub fn update(self: *Grid, comptime app: *const App, state: anytype) !void {
        for (self.children.items) |item| {
            inline for (app.elements) |field| {
                if (std.mem.eql(u8, field.name, item.name)) {}
            }
        }
    }

    pub fn render(self: *Grid, comptime app: *const App, result: *BuildResult) !void {
        for (self.children.items) |item| {
            inline for (app.elements) |field| {
                if (std.mem.eql(u8, field.name, item.name)) {
                    try @intToPtr(*field.default_value.?, item.ptr).render(result);
                }
            }
        }
    }
};

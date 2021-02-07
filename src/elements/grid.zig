const std = @import("std");
const App = @import("../app.zig").App;

const Style = @import("../style.zig").Style;
const Allocator = std.mem.Allocator;
const print = std.debug.print;

usingnamespace @import("../math.zig");

pub const Detail = struct {
    auto: bool = false,
    count: u16 = 1,
    gap: u16 = 0,
};

pub const Grid = struct {
    style: Style,
    rows: Detail,
    columns: Detail,
    children: std.ArrayList(Child),

    pub const Child = struct {
        name: []const u8,
        ptr: usize,

        pub fn from(element: anytype) Child {
            return Child{
                .name = @typeName(@TypeOf(element)),
                .ptr = @ptrToInt(&element),
            };
        }
    };

    pub fn new(config: struct { style: Style, rows: Detail, columns: Detail }, allocator: *Allocator) Grid {
        return Grid{
            .style = config.style,
            .columns = config.columns,
            .rows = config.rows,
            .children = std.ArrayList(Child).init(allocator),
        };
    }

    pub fn append(self: *Grid, element: anytype) *Grid {
        self.children.append(Child.from(element)) catch unreachable;
        return self;
    }

    pub fn appendSlice(self: *Grid, elements: []const Child) *Grid {
        self.children.appendSlice(elements) catch unreachable;
        return self;
    }

    pub fn init(self: *Grid, comptime app: App, state: anytype) !void {}
    pub fn update(self: *Grid, comptime app: App, state: anytype) !void {
        for (self.children.items) |item| {
            inline for (app.elements) |field| {
                if (std.mem.eql(u8, field.name, item.name)) {
                    @intToPtr(*field.default_value.?, item.ptr).update(app, state) catch unreachable;
                }
            }
        }
    }

    pub fn render(self: *Grid, comptime app: App, result: *BuildResult) !void {
        for (self.children.items) |item| {
            inline for (app.elements) |field| {
                if (std.mem.eql(u8, field.name, item.name)) {
                    @intToPtr(*field.default_value.?, item.ptr).render(app, result) catch unreachable;
                }
            }
        }
    }

    pub fn deinit(self: *Grid) void {
        self.children.deinit();
    }
};

const std = @import("std");

const Style = @import("../style.zig").Style;
const callElements = @import("../meta.zig").callElements;
const Allocator = std.mem.Allocator;
const print = std.debug.print;

usingnamespace @import("../math.zig");

pub const Grid = struct {
    style: Style,
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

    pub fn new(style: Style, allocator: *Allocator) Grid {
        return Grid{
            .style = style,
            .children = std.ArrayList(Child).init(allocator),
        };
    }

    pub fn append(self: *Grid, child: anytype) *Grid {
        self.children.append(Child.from(child)) catch unreachable;
        return self;
    }

    pub fn appendSlice(self: *Grid, children: []const Child) *Grid {
        self.children.appendSlice(children) catch unreachable;
        return self;
    }

    pub fn update(self: *Grid, state: anytype) !void {
        callElements(self.children.items, "update", state) catch unreachable;
    }

    pub fn render(self: *Grid, result: *BuildResult) !void {
        callElements(self.children.items, "render", state) catch unreachable;
    }

    pub fn deinit(self: *Grid) void {
        self.children.deinit();
    }
};

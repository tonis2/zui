const std = @import("std");

const Style = @import("../style.zig").Style;
const DrawBuffer = @import("../drawing.zig").DrawBuffer;
const root = @import("root");
const callEach = @import("../meta.zig").callEach;

const Allocator = std.mem.Allocator;
const print = std.debug.print;


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

pub const Grid = struct {
    style: Style,
    children: std.ArrayList(Child),

    pub fn new(style: Style, allocator: *Allocator) Grid {
        return Grid{
            .style = style,
            .children = std.ArrayList(Child).init(allocator),
        };
    }

    pub fn append(self: *Grid, child: anytype) void {
        self.children.append(Child.from(child)) catch unreachable;
    }

    pub fn appendSlice(self: *Grid, children: []const Child) *Grid {
        self.children.appendSlice(children) catch unreachable;
        return self;
    }

    pub fn update(self: *Grid, state: anytype) void {
        callEach(self.children.items, "update", state);
    }

    pub fn render(self: *Grid, result: *DrawBuffer) void {
        callEach(self.children.items, "render", result);
    }

    pub fn deinit(self: *Grid) void {
        self.children.deinit();
    }
};

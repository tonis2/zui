const std = @import("std");

const Style = @import("../style.zig");
const DrawBuffer = @import("../drawing.zig").DrawBuffer;
const root = @import("root");
const callEach = @import("../meta.zig").callEach;

const Allocator = std.mem.Allocator;
const print = std.debug.print;

const Self = @This();

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

style: Style,
children: std.ArrayList(Child),

pub fn new(style: Style, allocator: *Allocator) Self {
    return Self{
        .style = style,
        .children = std.ArrayList(Child).init(allocator),
    };
}

pub fn append(self: *Self, child: anytype) void {
    self.children.append(Child.from(child)) catch unreachable;
}

pub fn appendSlice(self: *Self, children: []const Child) void {
    self.children.appendSlice(children) catch unreachable;
    return self;
}

pub fn update(self: *Self, app: anytype) void {
    callEach(self.children.items, "update", app);
}

pub fn render(self: *Self, result: *DrawBuffer) void {
    callEach(self.children.items, "render", result);
}

pub fn deinit(self: *Self) void {
    self.children.deinit();
}

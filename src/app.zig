const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;
const TypeInfo = std.builtin.TypeInfo;
const BuildResult = @import("./math.zig").BuildResult;

pub const App = struct {
    elements: []const TypeInfo.StructField,

    pub fn new(elements: anytype) App {
        return App{
            .elements = @typeInfo(@TypeOf(elements)).Struct.fields,
        };
    }
};

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

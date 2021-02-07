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



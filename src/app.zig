const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;
const TypeInfo = std.builtin.TypeInfo;

const Vertex = @import("./math.zig").Vertex;
const MeshData = @import("./math.zig").MeshData;

pub const App = struct {
    elements: []const TypeInfo.StructField,

    pub fn new(elements: anytype) App {
        return App{
            .elements = @typeInfo(@TypeOf(elements)).Struct.fields,
        };
    }
};

pub const BuildResult = struct {
    vertices: std.ArrayList(Vertex),
    indices: std.ArrayList(u16),

    pub fn new(allocator: *Allocator) BuildResult {
        return BuildResult{
            .vertices = std.ArrayList(Vertex).init(allocator),
            .indices = std.ArrayList(u16).init(allocator),
        };
    }

    pub fn add(self: *BuildResult, data: MeshData) !void {
        for (data.indices) |value| {
            try self.indices.append(value + @intCast(u16, self.indices.items.len));
        }

        for (data.vertices) |vert| {
            try self.vertices.append(vert);
        }
    }

    pub fn clear(self: *BuildResult) void {
        self.vertices.shrink(0);
        self.indices.shrink(0);
    }

    pub fn deinit(self: *BuildResult) void {
        self.vertices.deinit();
        self.indices.deinit();
    }
};

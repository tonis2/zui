const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;

const BuildResult = @import("./math.zig").BuildResult;

pub const App = struct {
    registry: std.ArrayList(usize),

    pub fn new(allocator: *Allocator) App {
        return App{
            .registry = std.ArrayList(usize).init(allocator),
        };
    }

    pub fn add(self: *App, element: anytype) !void {
        try self.registry.append(@ptrToInt(&element));
    }
};

// pub fn build(element: anytype) void {
//     return switch (@TypeOf(element)) {
//         .Editor => {
//             var el = @intToPtr(*Editor, element.ptr);
//             try el.render(&result, element, &state);
//         },
//         .Rectangle => {
//             var el = @intToPtr(*Rectangle, element.ptr);
//             try el.render(&result, element, &state);
//         },
//         .Label => {
//             var el = @intToPtr(*Label, element.ptr);
//             try el.render(&result, element, &state);
//         },
//     };
// }

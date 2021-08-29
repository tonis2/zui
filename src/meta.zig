const root = @import("root");
const std = @import("std");

usingnamespace @import("zalgebra");

pub fn bubbleSort(comptime listType: type, list: *std.ArrayList(listType), compare: fn compareFn(firstValue: anytype, secondValue: anytype) bool) void {
    for (list.items) |_| {
        for (list.items) |item, index| {
            if (index == list.items.len - 1) break;
            if (compare(item, list.items[index + 1])) {
                std.mem.swap(listType, &list.items[index], &list.items[index + 1]);
            }
        }
    }
}

// *
// Iter over all the all the list items and find the matching type from CustomElements registry, then fire their update or render fn
//

pub fn callEach(list: anytype, comptime command: []const u8, payload: anytype) void {
    for (list) |child| {
        var b = brk: inline for (root.CustomElements) |element| {
            if (std.mem.eql(u8, element.name, child.name)) {
                var pointer = @intToPtr(*element.type, child.ptr);
                @field(pointer, command)(payload);
                break :brk;
            }
        };
        _ = b;
    }
}

pub const Element = struct {
    name: []const u8,
    type: type,

    pub fn new(name: []const u8, comptime elType: type) Element {
        return Element{
            .name = name,
            .type = elType,
        };
    }
};

pub const Vertex = struct { pos: Vec3, color: Vec4 };

// Has click event
//         if (@hasField(element.default_value.?, "click")) {
//             if (pointer.click) |event| {
//                 std.debug.print("has click\n", .{});
//                 event(pointer);
//             }
//         }

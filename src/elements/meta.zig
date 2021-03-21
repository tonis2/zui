const elements = @import("elements");
const std = @import("std");

pub fn callElements(list: anytype, comptime command: []const u8, state: anytype) !void {
    const element_list = @typeInfo(elements).Struct.decls;
    for (list) |item| {
        inline for (element_list) |element| {
            if (std.mem.eql(u8, element.name, item.name)) {
                var elem = @intToPtr(*element.data.Type, item.ptr);
                try @field(elem, command)(state);
                break;
            }
        }
    }
}

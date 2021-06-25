const root = @import("root");
const std = @import("std");

// *
// Iter over all the all the list items and find the matching type from CustomElements registry, then fire their update or render fn
//

pub fn callEach(list: anytype, comptime command: []const u8, state: anytype) void {
    const fields = std.meta.fields(@TypeOf(root.CustomElements));
    inline for (fields) |element| {
        for (list) |child| {
            if (std.mem.eql(u8, element.name, child.name)) {
                @field(@intToPtr(*element.default_value.?, child.ptr), command)(state);
                break;
            }
        }
    }
}

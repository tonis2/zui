const std = @import("std");
const Context = @import("./context.zig");
const Swapchain = @import("./swapchain.zig").Swapchain;
const GraphicsContext = Context.GraphicsContext;
const Allocator = std.mem.Allocator;
const vk = @import("vulkan");
const Pipeline = @import("./pipelines/default.zig");

const app_name = "vulkan-zig triangle example";

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

pub fn init(allocator: *Allocator) !void {
    defer std.debug.assert(!gpa.deinit());

    const context = try GraphicsContext.init(allocator, app_name, window);
    defer context.deinit();

    std.debug.print("Using device: {s}\n", .{context.deviceName()});

    const extent = vk.Extent2D{ .width = 800, .height = 600 };
    var swapchain = try Swapchain.init(&context, allocator, extent);
    defer swapchain.deinit();

    var pipeline = Pipeline.new(&context);
    defer pipeline.deinit();
}

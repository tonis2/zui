const std = @import("std");
const vk = @import("vulkan");
const c = @import("c");
const resources = @import("resources");
const GraphicsContext = @import("graphics_context").GraphicsContext;
const Swapchain = @import("swapchain.zig").Swapchain;
const Allocator = std.mem.Allocator;

pub fn run() !void {
    if (c.glfwInit() != c.GLFW_TRUE) return error.GlfwInitFailed;
    defer c.glfwTerminate();
}

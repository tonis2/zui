const zui = @import("zui");
const std = @import("std");
const Vulkan = @import("vulkan");

const DrawBuffer = zui.DrawBuffer;

const Context = Vulkan.Context;
const Buffer = Vulkan.Buffer;
const Window = Vulkan.Window;

usingnamespace Vulkan.C;
usingnamespace Vulkan.Utils;

usingnamespace zui.Meta;
usingnamespace zui.Elements;

pub const Pipeline = @import("backend/pipeline.zig");
pub const Renderpass = @import("backend/renderpass.zig");

const print = std.debug.print;

pub const CustomElements = [2]Element{ Element.new("text", Text), Element.new("grid", Grid) };

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

const State = struct {
    name: []const u8,
};

var App: zui.App(State) = .{ .state = .{ .name = "test" }, .width = 200.0, .height = 200.0 };

const vertices = [_]Vertex{
    Vertex{ .position = Vec3.new(-0.5, -0.5, 1.0), .color = Vec4.new(1.0, 0.0, 0.0, 1.0) },
    Vertex{ .position = Vec3.new(0.5, -0.5, 1.0), .color = Vec4.new(0.0, 1.0, 0.0, 1.0) },
    Vertex{ .position = Vec3.new(0.5, 0.5, 1.0), .color = Vec4.new(0.0, 0.0, 1.0, 1.0) },
    Vertex{ .position = Vec3.new(-0.5, 0.5, 1.0), .color = Vec4.new(1.0, 1.0, 1.0, 1.0) },
};

const v_indices = [_]u16{ 0, 1, 2, 2, 3, 0 };

fn changeState(self: *Text) void {
    self.text = "test updated";
    std.debug.print("{d} \n", .{App.width});
}

pub fn main() !void {
    defer std.debug.assert(!gpa.deinit());

    // Build GUI elements
    var result = DrawBuffer.new(allocator);
    defer result.deinit();

    var text = Text{ .text = "test3", .layout = .{ .width = 300, .height = 300, .x = 100, .y = 100 } };

    text.update(&App);
    text.render(&result);

    // Initialize Vulkan
    const window = try Window.init(1400, 900);
    errdefer window.deinit();
    var context = try Context.init(allocator, window);

    const renderpass = try Renderpass.init(context);
    const pipeline = try Pipeline.init(context, renderpass.renderpass);

    const vertex_buffer = try Buffer(Vertex, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT).init(context, &vertices);
    const index_buffer = try Buffer(u16, VK_BUFFER_USAGE_INDEX_BUFFER_BIT).init(context, &v_indices);

    defer {
        vertex_buffer.deinit(context);
        index_buffer.deinit(context);
        renderpass.deinit(context);
        pipeline.deinit(context);
        window.deinit();
        context.deinit();
    }

    while (!window.shouldClose()) {
        for (context.vulkan.commandbuffers) |buffer, i| {
            const begin_info = VkCommandBufferBeginInfo{
                .sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
                .pNext = null,
                .flags = 0,
                .pInheritanceInfo = null,
            };

            try checkSuccess(vkBeginCommandBuffer(buffer, &begin_info), error.VulkanBeginCommandBufferFailure);

            const clear_color = [_]VkClearValue{VkClearValue{
                .color = VkClearColorValue{ .float32 = [_]f32{ 0.0, 0.0, 0.0, 1.0 } },
            }};

            const render_pass_info = VkRenderPassBeginInfo{
                .sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO,
                .pNext = null,
                .renderPass = renderpass.renderpass,
                .framebuffer = renderpass.framebuffers[i],
                .renderArea = VkRect2D{
                    .offset = VkOffset2D{ .x = 0, .y = 0 },
                    .extent = context.vulkan.swapchain.extent,
                },
                .clearValueCount = 1,
                .pClearValues = &clear_color,
            };

            vkCmdBeginRenderPass(buffer, &render_pass_info, VK_SUBPASS_CONTENTS_INLINE);
            vkCmdBindPipeline(buffer, VK_PIPELINE_BIND_POINT_GRAPHICS, pipeline.pipeline);

            const vertex_buffers = [_]VkBuffer{vertex_buffer.buffer};
            const offsets = [_]VkDeviceSize{0};
            vkCmdBindVertexBuffers(buffer, 0, 1, &vertex_buffers, &offsets);
            vkCmdBindIndexBuffer(buffer, index_buffer.buffer, 0, VK_INDEX_TYPE_UINT16);
            vkCmdDrawIndexed(buffer, @intCast(u32, index_buffer.len), 1, 0, 0, 0);
            vkCmdEndRenderPass(buffer);

            try checkSuccess(vkEndCommandBuffer(buffer), error.VulkanCommandBufferEndFailure);
        }

        try context.renderFrame(context.vulkan.commandbuffers);
    }
}

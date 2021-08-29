const zui = @import("zui");
const std = @import("std");
const Vulkan = @import("vulkan");

const Context = Vulkan.Context;
const Buffer = Vulkan.Buffer;
const Window = Vulkan.Window;

usingnamespace Vulkan.C;
usingnamespace Vulkan.Utils;

const DrawBuffer = zui.DrawBuffer;
usingnamespace zui.Meta;
usingnamespace zui.Elements;
usingnamespace @import("zalgebra");

pub const Pipeline = @import("backend/pipeline.zig");
pub const Renderpass = @import("backend/renderpass.zig");

// pub const CustomElements = [2]Element{ Element.new("text", Text), Element.new("grid", Grid) };

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

const State = struct {
    name: []const u8,
};

var App: zui.App(State) = .{ .state = .{ .name = "test" }, .width = 1400.0, .height = 800.0 };

pub fn main() !void {
    defer std.debug.assert(!gpa.deinit());

    // Build GUI elements
    var result = DrawBuffer.new(allocator);
    defer result.deinit();

    try result.drawRectangle(100, 200, 200, 200, Vec4.new(1.0, 1.0, 1.0, 1.0), .{ .shader = 2 });
    try result.drawRectangle(310, 200, 200, 200, Vec4.new(1.0, 1.0, 1.0, 1.0), .{ .shader = 2 });
    try result.drawRectangle(520, 200, 200, 200, Vec4.new(1.0, 1.0, 1.0, 1.0), .{ .shader = 1 });
    try result.drawRectangle(730, 200, 200, 200, Vec4.new(1.0, 1.0, 1.0, 1.0), .{ .shader = 1 });

    // Sort draw calls
    result.build();

    // Initialize Vulkan
    const window = try Window.init(App.width, App.height);
    errdefer window.deinit();

    var vulkan = try Vulkan.init(allocator, window);
    errdefer vulkan.deinit();

    var syncronisation = try Vulkan.Synchronization.init(&vulkan, allocator, vulkan.swapchain.images.len);
    errdefer syncronisation.deinit();

    const renderpass = try Renderpass.init(vulkan);
    const pipeline = try Pipeline.init(vulkan, renderpass.renderpass);
    const vertex_buffer = try Buffer.From(Vertex, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT).init(vulkan, result.vertices.items);
    const index_buffer = try Buffer.From(u16, VK_BUFFER_USAGE_INDEX_BUFFER_BIT).init(vulkan, result.indices.items);

    defer {
        _ = vkDeviceWaitIdle(vulkan.device);

        vertex_buffer.deinit(vulkan);
        index_buffer.deinit(vulkan);
        renderpass.deinit(vulkan);
        pipeline.deinit(vulkan);
        syncronisation.deinit();
        vulkan.deinit();
        window.deinit();
    }

    // _ = glfwSetKeyCallback(window.window, keyCallback);

    while (!window.shouldClose()) {
        window.pollEvents();
        for (vulkan.commandbuffers) |buffer, i| {
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
                    .extent = vulkan.swapchain.extent,
                },
                .clearValueCount = 1,
                .pClearValues = &clear_color,
            };

            vkCmdBeginRenderPass(buffer, &render_pass_info, VK_SUBPASS_CONTENTS_INLINE);
            vkCmdBindPipeline(buffer, VK_PIPELINE_BIND_POINT_GRAPHICS, pipeline.pipeline);
            vkCmdBindDescriptorSets(buffer, VK_PIPELINE_BIND_POINT_GRAPHICS, pipeline.layout, 0, 1, &[_]VkDescriptorSet{pipeline.descriptorSets}, 0, null);

            vkCmdBindVertexBuffers(buffer, 0, 1, &[_]VkBuffer{vertex_buffer.buffer}, &[_]VkDeviceSize{0});
            vkCmdBindIndexBuffer(buffer, index_buffer.buffer, 0, VK_INDEX_TYPE_UINT16);

            vkCmdDrawIndexed(buffer, @intCast(u32, index_buffer.len), 1, 0, 0, 0);
            vkCmdEndRenderPass(buffer);

            try checkSuccess(vkEndCommandBuffer(buffer), error.VulkanCommandBufferEndFailure);
        }

        try syncronisation.drawFrame(vulkan.commandbuffers);
    }
}

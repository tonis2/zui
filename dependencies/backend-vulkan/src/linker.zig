const std = @import("std");
const Step = std.build.Step;
const Builder = std.build.Builder;
const LibExeObjStep = std.build.LibExeObjStep;
const Pkg = std.build.Pkg;

const vkgen = @import("../dependencies/vulkan-zig/generator/index.zig");
const ResourceGenStep = @import("../dependencies/vulkan-zig/build.zig").ResourceGenStep;

pub fn attachTo(exe: *LibExeObjStep) void {
    const b = exe.builder;
    const vk_xml_path = b.option([]const u8, "vulkan-registry", "Override the to the Vulkan registry") orelse "dependencies/backend-vulkan/dependencies/vulkan-zig/examples/vk.xml";
    const gen = vkgen.VkGenerateStep.init(b, vk_xml_path, "vk.zig");

    const generator_exe = b.addExecutable("vulkan-zig-generator", "dependencies/backend-vulkan/dependencies/vulkan-zig/generator/main.zig");
    generator_exe.setTarget(exe.target);
    generator_exe.setBuildMode(exe.build_mode);
    generator_exe.install();

    exe.install();
    exe.linkLibC();
    exe.linkSystemLibrary("glfw");

    const shaders = ResourceGenStep.init(b, "resources.zig");
    shaders.addShader("triangle_vert", "dependencies/backend-vulkan/shaders/triangle.vert");
    shaders.addShader("triangle_frag", "dependencies/backend-vulkan/shaders/triangle.frag");

    exe.step.dependOn(&gen.step);
    exe.step.dependOn(&shaders.step);

    exe.addPackage(
        .{ .name = "vulkan-backend", .path = "dependencies/backend-vulkan/src/vulkan.zig", .dependencies = &[_]Pkg{
            .{
                .name = "graphics_context",
                .path = "dependencies/backend-vulkan/dependencies/vulkan-zig/examples/graphics_context.zig",
            },
            .{
                .name = "c",
                .path = "dependencies/backend-vulkan/dependencies/vulkan-zig/examples/c.zig",
            },
            gen.package,
            shaders.package,
        } },
    );
}

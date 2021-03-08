const std = @import("std");
const Step = std.build.Step;
const Builder = std.build.Builder;


const vkgen = @import("/dependencies/vulkan-zig/generator/index.zig");
const ResourceGenStep = @import("/dependencies/vulkan-zig/build.zig").ResourceGenStep;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const generator_exe = b.addExecutable("vulkan-zig-generator", "./dependencies/vulkan-zig/generator/main.zig");
    generator_exe.setTarget(target);
    generator_exe.setBuildMode(mode);
    generator_exe.install();

    const vk_xml_path = b.option([]const u8, "vulkan-registry", "Override the to the Vulkan registry") orelse "./dependencies/vulkan-zig/examples/vk.xml";
    const gen = vkgen.VkGenerateStep.init(b, vk_xml_path, "vk.zig");

    const lib = b.addStaticLibrary("vulkan", "src/vulkan.zig");
    lib.setTarget(target);
    lib.setBuildMode(mode);
    lib.install();
    lib.linkLibC();
    lib.linkSystemLibrary("glfw");

    lib.addPackage(
        .{
            .name = "graphics_context",
            .path = "./dependencies/vulkan-zig/examples/graphics_context.zig",
        },
    );

    lib.addPackage(
        .{
            .name = "c",
            .path = "./dependencies/vulkan-zig/examples/c.zig",
        },
    );

    const shaders = ResourceGenStep.init(b, "resources.zig");
    shaders.addShader("triangle_vert", "shaders/triangle.vert");
    shaders.addShader("triangle_frag", "shaders/triangle.frag");

    lib.step.dependOn(&gen.step);
    lib.addPackage(gen.package);

    lib.step.dependOn(&shaders.step);
    lib.addPackage(shaders.package);
}

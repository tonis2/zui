const Builder = @import("std").build.Builder;
const fmt = std.fmt;
const std = @import("std");
const Pkg = std.build.Pkg;
const print = std.debug.print;

pub fn build(b: *Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const examples = [_][2][]const u8{
        .{ "basic", "examples/basic.zig" },
    };

    const vulkan = Pkg{ .name = "vulkan", .path = std.build.FileSource{ .path = "dependencies/vulkan-experiment/src/vulkan.zig" } };
    const zalgebra = Pkg{ .name = "zalgebra", .path = std.build.FileSource{ .path = "dependencies/zalgebra/src/main.zig" } };
    const zui = Pkg{ .name = "zui", .path = std.build.FileSource{ .path = "src/zui.zig" }, .dependencies = &[_]Pkg{zalgebra} };

    for (examples) |example| {
        const name = example[0];
        const path = example[1];
        const exe = b.addExecutable(name, path);

        exe.setTarget(target);
        exe.setBuildMode(mode);

        exe.addPackage(zui);
        exe.addPackage(vulkan);
        exe.addPackage(zalgebra);

        exe.linkLibC();
        exe.linkSystemLibrary("glfw");
        exe.linkSystemLibrary("vulkan");

        exe.install();

        const run_cmd = exe.run();
        run_cmd.step.dependOn(b.getInstallStep());

        const run_step = b.step(name, "Run the app");
        run_step.dependOn(&run_cmd.step);
    }
}

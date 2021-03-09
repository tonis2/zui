const Builder = @import("std").build.Builder;
const fmt = std.fmt;
const std = @import("std");
const print = std.debug.print;

const vulkan = @import("/dependencies/backend-vulkan/src/linker.zig");

pub fn build(b: *Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const examples = [_][2][]const u8{
        .{ "basic", "examples/basic.zig" },
    };

    for (examples) |example| {
        const name = example[0];
        const path = example[1];
        const exe = b.addExecutable(name, path);

        exe.setTarget(target);
        exe.setBuildMode(mode);

        exe.addPackage(.{
            .name = "zui",
            .path = "src/zui.zig",
        });

        vulkan.attachTo(exe);

        exe.install();

        const run_cmd = exe.run();
        run_cmd.step.dependOn(b.getInstallStep());

        const run_step = b.step(name, "Run the app");
        run_step.dependOn(&run_cmd.step);
    }
}

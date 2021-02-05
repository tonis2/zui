const Builder = @import("std").build.Builder;
const fmt = std.fmt;
const std = @import("std");
const print = std.debug.print;

pub fn build(b: *Builder) !void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const examples = [_][2][]const u8{
        .{ "basic", "examples/basic.zig" },
    };

    for (examples) |example| {
        const name = example[0];
        const path = example[1];
        const exe = b.addExecutable(name, path);

        exe.addPackage(
            .{
                .name = "zui",
                .path = "src/zui.zig",
            },
        );

        exe.setTarget(target);
        exe.setBuildMode(mode);
        exe.install();

        const run_cmd = exe.run();
        run_cmd.step.dependOn(b.getInstallStep());

        const run_step = b.step(name, "Run the app");
        run_step.dependOn(&run_cmd.step);
    }
}
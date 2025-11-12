const std = @import("std");

// TODO: Build for more architectures like ARM.
pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .os_tag = .linux,
    });

    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("liebenC", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "liebenC",
        .root_module = mod,
        .linkage = .dynamic,
        .version = .{ .major = 0, .minor = 0, .patch = 0 },
    });

    const crt0 = b.addObject(.{
        .name = "crt0",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/runtime/crt0.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    b.installArtifact(lib);

    const test_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });

    test_mod.addObject(crt0);
    test_mod.addCSourceFiles(.{
        .root = b.path("test"),
        .files = &.{
            "simple.c",
        },
        .flags = &[_][]const u8{ "-nostdlib", "-nodefaultlibs" },
    });

    const test_runner = b.addExecutable(.{
        .name = "runner",
        .root_module = test_mod,
    });

    test_runner.linkLibrary(lib);
    b.installArtifact(test_runner);
}

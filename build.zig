const std = @import("std");
const builtin = @import("builtin");
const native_arch = builtin.cpu.arch;

// TODO: Build for more architectures like ARM.
pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .os_tag = .linux,
    });

    const optimize = b.standardOptimizeOption(.{});

    const crt0 = b.addObject(.{
        .name = "crt0",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/crt0.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    // Configure the types based on architecture and add include path.
    const alltypes = b.addConfigHeader(
        .{
            .style = .{ .autoconf_undef = b.path("include/alltypes.h.in") },
            .include_path = "bits/alltypes.h",
        },
        .{
            ._Addr = switch (native_arch) {
                .x86_64 => .long,
                else => @compileError("unsupported architecture"),
            },
            ._Int64 = switch (native_arch) {
                .x86_64 => .long,
                else => @compileError("unsupported architecture"),
            },
        },
    );

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

    lib.root_module.addConfigHeader(alltypes);

    const headers = [_][]const u8{
        "include/stdint.h",
        "include/stddef.h",
        "include/stdio.h",
    };

    lib.installConfigHeader(alltypes);
    b.installArtifact(lib);
    for (headers) |h| {
        lib.installHeader(b.path(h), std.fs.path.basename(h));
    }

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
        .flags = &[_][]const u8{ "-std=c23", "-nostdlib", "-nodefaultlibs" },
    });

    const test_runner = b.addExecutable(.{
        .name = "runner",
        .root_module = test_mod,
    });

    test_runner.linkLibrary(lib);
    b.installArtifact(test_runner);
}

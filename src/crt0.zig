const builtin = @import("builtin");
const native_arch = builtin.cpu.arch;
const elf = @import("elf.zig");

// Same thing imported in the root.zig.
pub const syscall = switch (native_arch) {
    .x86_64 => @import("arch/x86_64/syscall.zig"),
    else => @compileError("unsupported architecture"),
};

extern var global_auxv: ?[*]elf.auxv_t;

extern fn main(
    argc: usize,
    argv: [*][*:0]u8,
    envp: [*:null]?[*:0]u8,
) callconv(.c) usize;

export fn _start() callconv(.naked) noreturn {
    switch (native_arch) {
        .x86_64 => {
            // rbp should be zero on some debugger stuff.
            // Also set the stack as the first argument.
            // The callMain function automatically sets it to the rbp.
            asm volatile (
                \\ xor %%rbp, %%rbp
                \\ movq %%rsp, %%rdi
            );

            // Call the start.
            asm volatile (
                \\ callq %[callMain:P]
                :
                : [callMain] "X" (&callMain),
            );
        },
        else => @compileError("unsupported architecture"),
    }
}

// Same as the zig posixCallMainAndExit.
fn callMain(stack: [*]usize) callconv(.c) noreturn {
    @setRuntimeSafety(false);
    @disableInstrumentation();
    const argc = stack[0];
    const argv: [*][*:0]u8 = @ptrCast(stack + 1);
    // alignCast is necessary for future architectures like embedded ones.
    // Not sure why argv must be first :))
    const envp_start: [*:null]?[*:0]u8 = @ptrCast(@alignCast(argv + argc + 1));
    // Check if we have an envp or we have reached a zero which means end.
    var envp_size: usize = 0;
    while (envp_start[envp_size]) |_| : (envp_size += 1) {}
    const envp = @as([*][*:0]u8, @ptrCast(envp_start))[0..envp_size];

    const auxv: [*]elf.auxv_t = @ptrCast(@alignCast(envp.ptr + envp_size + 1));
    global_auxv = auxv;

    const ret = main(argc, argv, @ptrCast(envp));

    // For some insane reason the exit code is 1 in x86 and 60 in x86_64.
    _ = syscall.syscall1(60, ret);

    unreachable;
}

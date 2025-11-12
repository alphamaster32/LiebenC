const builtin = @import("builtin");
const native_arch = builtin.cpu.arch;

extern fn main(argc: usize, argv: [*][*:0]u8) callconv(.c) usize;

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

    _ = main(argc, argv);

    // Call the exit syscall.
    asm volatile (
        \\ movq %%rax, %%rdi
        \\ movq $60, %%rax
        \\ syscall
    );

    unreachable;
}

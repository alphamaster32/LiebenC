const builtin = @import("builtin");
const native_arch = builtin.cpu.arch;

pub const syscall = switch (native_arch) {
    .x86_64 => @import("arch/x86_64/syscall.zig"),
    else => @compileError("unsupported architecture"),
};

export fn __tls_get_addr() void {}
export fn getauxval() void {}

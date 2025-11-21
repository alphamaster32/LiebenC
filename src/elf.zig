const builtin = @import("builtin");
const native_arch = builtin.cpu.arch;

pub const auxv_t = switch (native_arch) {
    .x86_64 => extern struct {
        a_type: u64,
        a_un: extern union {
            a_val: u64,
            a_ptr: *opaque {},
            a_func: *const fn () callconv(.c) void,
        },
    },
    else => @compileError("unsupported architecture"),
};

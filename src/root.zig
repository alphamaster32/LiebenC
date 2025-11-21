const builtin = @import("builtin");
const native_arch = builtin.cpu.arch;
const elf = @import("elf.zig");

pub const syscall = switch (native_arch) {
    .x86_64 => @import("arch/x86_64/syscall.zig"),
    else => @compileError("unsupported architecture"),
};

pub export var global_auxv: ?[*]elf.auxv_t = null;

export fn __tls_get_addr() void {}

export fn getauxval(a_type: usize) usize {
    const auxv = global_auxv orelse return 0;
    var i: usize = 0;

    while (auxv[i].a_type != 0) : (i += 1) {
        if (auxv[i].a_type == a_type) {
            return auxv[i].a_un.a_val;
        }
    }

    return 0;
}

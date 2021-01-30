//! SFML.zig - unofficial binding of CSFML to Zig
//! Written by Natalia Cholewa, 2021
//!
//! SFML.zig repository:
//! https://github.com/natanalt/sfml.zig
//!
//! Official SFML website:
//! https://www.sfml-dev.org
//!

pub const bindings_version = @import("std").builtin.Version.parse("0.1.0") catch unreachable;

const root = @import("root");
pub const allocator = if (@hasDecl(root, "sfml_zig_allocator"))
    root.sfml_zig_allocator
else
    @import("std").heap.c_allocator;

pub const system = @import("system.zig");
pub const window = @import("window.zig");

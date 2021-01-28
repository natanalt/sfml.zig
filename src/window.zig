//! SFML.zig window module bindings
//!

const std = @import("std");
const system = @import("system.zig");
pub const c = @cImport({ @cInclude("SFML/Window.h"); });

fn cStringLength(buffer: anytype) usize {
    var len: usize = 0;
    while (buffer[len] != 0) : (len += 1) {}
    return len;
}

pub const clipboard = struct {
    pub fn getString() []const u8 {
        const string = c.sfClipboard_getString();
        return string[0..cStringLength(string)];
    }
    pub fn getUnicodeString() []const u32 {
        const string = @ptrCast([*]const u32, c.sfClipboard_getUnicodeString());
        return string[0..cStringLength(string)];
    }
    pub fn setString(s: [:0]const u8) void {
        c.sfClipboard_setString(s);
    }
    pub fn setStringAlloc(alloc: *std.mem.Allocator, s: []const u8) !void {
        setString(try alloc.dupeZ(u8, s));
    }
    pub fn setUnicodeString(s: [:0]const u32) void {
        c.sfClipboard_setUnicodeString(s);
    }
    pub fn setUnicodeStringAlloc(alloc: *std.mem.Allocator, s: []const u32) !void {
        setUnicodeString(try alloc.dupeZ(u32, s));
    }
};

pub const Context = struct {
    internal: *c.sfContext,

    pub fn create() !Context {
        return Context{ .internal = c.sfContext_create() orelse return error.SfmlError };
    }
    pub fn destroy(self: *Context) void {
        c.sfContext_destro(self.internal);
    }
    pub fn setActive(self: *Context, active: bool) bool {
        return c.sfContext_setActive(self.internal, @intCast(c.sfBool, @boolToInt(active))) == c.sfTrue;
    }
    pub fn getSettings(self: *const Context) ContextSettings {
        return ContextSettings.fromCSFML(c.sfContext_getSettings(self.internal));
    }
    pub fn getActiveContextId() u64 {
        return @intCast(u64, c.sfContext_getActiveContextId());
    }
};

pub const ContextSettings = struct {
    depth_bits: c_int,
    stencil_bits: c_int,
    antialiasing_level: c_int,
    major_version: c_int,
    minor_version: c_int,
    attribute_flags: u32,
    srgb_capable: bool,

    pub fn fromCSFML(cs: c.sfContextSettings) ContextSettings {
        return .{
            .depth_bits = cs.depthBits,
            .stencil_bits = cs.stencilBits,
            .antialiasing_level = cs.antialiasingLevel,
            .major_version = cs.majorVersion,
            .minor_version = cs.minorVersion,
            .attribute_flags = cs.attributeFlags,
            .srgb_capable = cs.sRgbCapable,
        };
    }

    pub fn toCSFML(self: *ContextSettings) sf.ContextSettings {
        return .{
            .depthBits = self.depth_bits,
            .stencilBits = self.stencil_bits,
            .antialiasingLevel = self.antialiasing_level,
            .majorVersion = self.major_version,
            .minorVersion = self.minor_version,
            .attributeFlags = self.attribute_flags,
            .sRgbCapable = self.srgb_capable,
        };
    }
};

pub const CursorType = extern enum(c_int) {
    cursor_arrow = c.sfCursorType.sfCursorArrow,
    cursor_arrow_wait = c.sfCursorType.sfCursorArrowWait,
    cursor_wait = c.sfCursorType.sfCursorWait,
    cursor_text = c.sfCursorType.sfCursorText,
    cursor_hand = c.sfCursorType.sfCursorHand,
    cursor_size_horizontal = c.sfCursorType.sfCursorSizeHorizontal,
    cursor_size_vertical = c.sfCursorType.sfCursorSizeVertical,
    cursor_size_top_left_bottom_right = c.sfCursorType.sfCursorSizeTopLeftBottomRight,
    cursor_size_bottom_left_top_right = c.sfCursorType.sfCursorSizeBottomLeftTopRight,
    cursor_size_all = c.sfCursorType.sfCursorSizeAll,
    cursor_cross = c.sfCursorType.sfCursorCross,
    cursor_help = c.sfCursorType.sfCursorHelp,
    cursor_not_allowed = c.sfCursorType.sfCursorNotAllowed,
};

pub const Cursor = struct {
    internal: *c.sfCursor,

    pub fn createFromPixels(pixels: []const u8, size: system.Vector2u, hotspot: system.Vector2u) !Cursor {
        std.debug.assert(pixels.len == size.x * size.y);
        return Cursor{
            .internal = c.sfCursor_createFromPixels(pixels.ptr, size, hotspot) orelse return error.SfmlError,
        };
    }
    pub fn createFromSystem(t: CursorType) !Cursor {
        return Cursor{
            .internal = c.sfCursor_createFromSystem(@intToEnum(c.sfCursorType, @enumToInt(t))) orelse return error.SfmlError,
        };
    }
    pub fn destroy(self: *Cursor) void {
        c.sfCursor_destroy(self.internal);
    }
};

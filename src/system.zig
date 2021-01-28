//! SFML.zig system module bindings
//!

pub const c = @cImport({ @cInclude("SFML/System.h"); });

pub fn sleep(time: Time) void {
    c.sfSleep(time.internal);
}

pub const InputStream = struct {
    readFn: fn (*InputStream, []u8) anyerror!i64,
    seekFn: fn (*InputStream, i64) anyerror!i64,
    tellFn: fn (*InputStream) anyerror!i64,
    getSizeFn: fn (*InputStream) anyerror!i64,

    /// Creates an sfInputStream instance based on provided stream. **Important:** `stream` pointer is assumed to be
    /// valid as long as CSFML wants to use it.
    pub fn toCSFML(stream: *InputStream) c.sfInputStream {
        return .{
            .read = inputStreamRead,
            .seek = inputStreamSeek,
            .tell = inputStreamTell,
            .getSize = inputStreamGetSize,
            .userData = stream,
        };
    }

    fn inputStreamRead(data: *c_void, size: c.sfInt64, user_data: *c_void) callconv(.C) c.sfInt64 {
        const self = @ptrCast(*InputStream, user_data);
        return self.readFn(self, @ptrCast([*]u8, data)[0..size]) catch -1;
    }

    fn inputStreamSeek(position: c.sfInt64, user_data: *c_void) callconv(.C) c.sfInt64 {
        const self = @ptrCast(*InputStream, user_data);
        return self.seekFn(self, @intCast(i64, position)) catch -1;
    }

    fn inputStreamTell(user_data: *c_void) callconv(.C) c.sfInt64 {
        const self = @ptrCast(*InputStream, user_data);
        return self.tellFn(self) catch -1;
    }

    fn inputStreamGetSize(user_data: *c_void) callconv(.C) c.sfInt64 {
        const self = @ptrCast(*InputStream, user_data);
        return self.getSizeFn(self) catch -1;
    }
};

pub const Mutex = struct {
    internal: *c.sfMutex,

    pub fn create() !Mutex {
        return Mutex{ .internal = c.sfMutex_create() orelse return error.SfmlError };
    }
    pub fn destroy(self: *Mutex) void {
        c.sfMutex_destroy(self.internal);
    }
    pub fn lock(self: *Mutex) void {
        c.sfMutex_lock(self.internal);
    }
    pub fn unlock(self: *Mutex) void {
        c.sfMutex_unlock(self.internal);
    }
};

pub const Thread = struct {
    internal: *c.sfThread,

    pub fn create(func: fn (?*c_void) callconv(.C) void, user_data: ?*c_void) !Thread {
        return Thread{
            .internal = c.sfThread_create(func, user_data) orelse return error.SfmlError,
        };
    }
    pub fn destroy(self: *Thread) void {
        c.sfThread_destroy(self.internal);
    }
    pub fn launch(self: *Thread) void {
        c.sfThread_launch(self.internal);
    }
    pub fn wait(self: *Thread) void {
        c.sfThread_wait(self.internal);
    }
    pub fn terminate(self: *Thread) void {
        c.sfThread_terminate(self.internal);
    }
};

pub const Time = struct {
    pub fn zero() Time {
        return .{ .internal = c.sfTime_Zero };
    }

    internal: c.sfTime,

    pub fn seconds(amount: f32) Time {
        return .{ .internal = c.sfSeconds(amount) };
    }
    pub fn milliseconds(amount: i32) Time {
        return .{ .internal = c.sfMilliseconds(@intCast(c.sfInt32, amount)) };
    }
    pub fn microseconds(amount: i64) Time {
        return .{ .internal = c.sfMicroseconds(@intCast(c.sfInt64, amount)) };
    }

    pub fn asSeconds(time: Time) f32 {
        return @floatCast(f32, c.sfTime_asSeconds(time.internal));
    }
    pub fn asMilliseconds(time: Time) i32 {
        return @intCast(i32, c.sfTime_asMilliseconds(time.internal));
    }
    pub fn asMicroseconds(time: Time) i64 {
        return @intCast(i64, c.sfTime_asMicroseconds(time.internal));
    }
};

pub const Clock = struct {
    internal: *c.sfClock,

    pub fn create() !Clock {
        return Clock{ .internal = c.sfClock_create() orelse return error.SfmlError };
    }
    pub fn destroy(self: *Clock) void {
        c.sfClock_destroy(self.internal);
    }
    pub fn copy(self: *const Clock) !Clock {
        return Clock{ .internal = c.sfClock_copy(self.internal) orelse return error.SfmlError };
    }
    pub fn getElapsedTime(self: *const Clock) Time {
        return .{ .internal = c.sfClock_getElapsedTime(self.internal) };
    }
    pub fn restart(self: *Clock) Time {
        return .{ .internal = c.sfClock_restart(self.internal) };
    }
};

pub const Vector2i = c.sfVector2i;
pub const Vector2u = c.sfVector2u;
pub const Vector2f = c.sfVector2f;

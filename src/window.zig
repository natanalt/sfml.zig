//! SFML.zig window module bindings
//!

const std = @import("std");
const sfml = @import("sfml.zig");
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
        c.sfClipboard_setString(s.ptr);
    }
    pub fn setStringAlloc(s: []const u8) !void {
        const str = try sfml.allocator.dupeZ(u8, s);
        defer sfml.allocator.free(str);
        setString(str);
    }
    pub fn setUnicodeString(s: [:0]const u32) void {
        c.sfClipboard_setUnicodeString(s.ptr);
    }
    pub fn setUnicodeStringAlloc(s: []const u32) !void {
        const str = try sfml.allocator.dupeZ(u32, s);
        defer sfml.allocator.free(str);
        setUnicodeString(str);
    }
};

pub const keyboard = struct {
    pub const Key = extern enum(c_int) {
        unknown = c.sfKeyUnknown,
        a = c.sfKeyA,
        b = c.sfKeyB,
        c = c.sfKeyC,
        d = c.sfKeyD,
        e = c.sfKeyE,
        f = c.sfKeyF,
        g = c.sfKeyG,
        h = c.sfKeyH,
        i = c.sfKeyI,
        j = c.sfKeyJ,
        k = c.sfKeyK,
        l = c.sfKeyL,
        m = c.sfKeyM,
        n = c.sfKeyN,
        o = c.sfKeyO,
        p = c.sfKeyP,
        q = c.sfKeyQ,
        r = c.sfKeyR,
        s = c.sfKeyS,
        t = c.sfKeyT,
        u = c.sfKeyU,
        v = c.sfKeyV,
        w = c.sfKeyW,
        x = c.sfKeyX,
        y = c.sfKeyY,
        z = c.sfKeyZ,
        num0 = c.sfKeyNum0,
        num1 = c.sfKeyNum1,
        num2 = c.sfKeyNum2,
        num3 = c.sfKeyNum3,
        num4 = c.sfKeyNum4,
        num5 = c.sfKeyNum5,
        num6 = c.sfKeyNum6,
        num7 = c.sfKeyNum7,
        num8 = c.sfKeyNum8,
        num9 = c.sfKeyNum9,
        escape = c.sfKeyEscape,
        left_control = c.sfKeyLControl,
        left_shift = c.sfKeyLShift,
        left_alt = c.sfKeyLAlt,
        left_system = c.sfKeyLSystem,
        right_control = c.sfKeyRControl,
        right_shift = c.sfKeyRShift,
        right_alt = c.sfKeyRAlt,
        right_system = c.sfKeyRSystem,
        menu = c.sfKeyMenu,
        left_bracket = c.sfKeyLBracket,
        right_bracket = c.sfKeyRBracket,
        semicolon = c.sfKeySemicolon,
        comma = c.sfKeyComma,
        period = c.sfKeyPeriod,
        quote = c.sfKeyQuote,
        slash = c.sfKeySlash,
        backslash = c.sfKeyBackslash,
        tilde = c.sfKeyTilde,
        equal = c.sfKeyEqual,
        hyphen = c.sfKeyHyphen,
        space = c.sfKeySpace,
        enter = c.sfKeyEnter,
        backspace = c.sfKeyBackspace,
        tab = c.sfKeyTab,
        page_up = c.sfKeyPageUp,
        page_down = c.sfKeyPageDown,
        end = c.sfKeyEnd,
        home = c.sfKeyHome,
        insert = c.sfKeyInsert,
        delete = c.sfKeyDelete,
        add = c.sfKeyAdd,
        subtract = c.sfKeySubtract,
        multiply = c.sfKeyMultiply,
        divide = c.sfKeyDivide,
        left = c.sfKeyLeft,
        right = c.sfKeyRight,
        up = c.sfKeyUp,
        down = c.sfKeyDown,
        numpad0 = c.sfKeyNumpad0,
        numpad1 = c.sfKeyNumpad1,
        numpad2 = c.sfKeyNumpad2,
        numpad3 = c.sfKeyNumpad3,
        numpad4 = c.sfKeyNumpad4,
        numpad5 = c.sfKeyNumpad5,
        numpad6 = c.sfKeyNumpad6,
        numpad7 = c.sfKeyNumpad7,
        numpad8 = c.sfKeyNumpad8,
        numpad9 = c.sfKeyNumpad9,
        f1 = c.sfKeyF1,
        f2 = c.sfKeyF2,
        f3 = c.sfKeyF3,
        f4 = c.sfKeyF4,
        f5 = c.sfKeyF5,
        f6 = c.sfKeyF6,
        f7 = c.sfKeyF7,
        f8 = c.sfKeyF8,
        f9 = c.sfKeyF9,
        f10 = c.sfKeyF10,
        f11 = c.sfKeyF11,
        f12 = c.sfKeyF12,
        f13 = c.sfKeyF13,
        f14 = c.sfKeyF14,
        f15 = c.sfKeyF15,
        pause = c.sfKeyPause,
        count = c.sfKeyCount,

        pub fn toCSFML(self: Key) c.sfKeyCode {
            return @intToEnum(c.sfKeyCode, @enumToInt(self));
        }
        pub fn fromCSFML(other: c.sfKeyCode) Key {
            return @intToEnum(Key, @enumToInt(other));
        }
    };

    pub fn isKeyPressed(key: Key) bool {
        return c.sfKeyboard_isKeyPressed(key.toCSFML()) == c.sfTrue;
    }
    pub fn setVirtualKeyboardVisible(visible: bool) void {
        c.sfKeyboard_setVirtualKeyboardVisible(@boolToInt(visible));
    }
};

pub const mouse = struct {
    pub const Button = extern enum(c_int) {
        left = c.sfMouseLeft,
        right = c.sfMouseRight,
        middle = c.sfMouseMiddle,
        x_button1 = c.sfMouseXButton1,
        x_button2 = c.sfMouseXButton2,

        pub fn toCSFML(self: Button) c.sfMouseButton {
            return @intToEnum(c.sfMouseButton, @enumToInt(self));
        }
        pub fn fromCSFML(other: c.sfMouseButton) Button {
            return @intToEnum(Button, @enumToInt(other));
        }
    };

    pub const Wheel = extern enum(c_int) {
        vertical_wheel = c.sfMouseVerticalWheel,
        horizontal_wheel = c.sfMouseHorizontalWheel,

        pub fn toCSFML(self: Wheel) c.sfMouseWheel {
            return @intToEnum(c.sfMouseWheel, @enumToInt(self));
        }
        pub fn fromCSFML(other: c.sfMouseWheel) Wheel {
            return @intToEnum(Wheel, @enumToInt(other));
        }
    };

    pub fn isButtonPressed(button: Button) bool {
        return c.sfMouse_isButtonPressed(button.toCSFML()) == c.sfTrue;
    }
    pub fn getPosition(relative_to: ?*const Window) system.Vector2i {
        return c.sfMouse_getPosition(relative_to.internal);
    }
    pub fn setPosition(position: system.Vector2i, relative_to: ?*const Window) void {
        c.sfMouse_setPosition(position, relative_to.internal);
    }
};

pub const joystick = struct {
    pub const count = c.sfJoystickCount;
    pub const button_count = c.sfJoystickButtonCount;
    pub const axis_count = c.sfJoystickAxisCount;

    pub const Axis = extern enum(c_int) {
        x = c.sfJoystickX,
        y = c.sfJoystickY,
        z = c.sfJoystickZ,
        r = c.sfJoystickR,
        u = c.sfJoystickU,
        v = c.sfJoystickV,
        pov_x = c.sfJoystickPovX,
        pov_y = c.sfJoystickPovY,

        pub fn toCSFML(self: Axis) c.sfJoystickAxis {
            return @intToEnum(c.sfJoystickAxis, @enumToInt(self));
        }
        pub fn fromCSFML(other: c.sfJoystickAxis) Axis {
            return @intToEnum(Axis, @enumToInt(other));
        }
    };

    pub const Identification = struct {
        name: []const u8,
        vendor_id: u32,
        product_id: u32,

        pub fn fromCSFML(csfml: c.sfJoystickIdentification) JoystickIdentification {
            return .{
                .name = csfml.name[0..cStringLength(csfml.name)],
                .vendor_id = @intCast(u32, csfml.vendorId),
                .product_id = @intCast(u32, csfml.productId),
            };
        }
    };

    pub fn isConnected(id: u32) bool {
        return c.sfJoystick_isConnected(@intCast(c_uint, id)) == c.sfTrue;
    }
    pub fn getButtonCount(id: u32) u32 {
        return @intCast(u32, c.sfJoystick_getButtonCount(@intCast(c_uint, id)));
    }
    pub fn hasAxis(id: u32, axis: Axis) bool {
        return c.sfJoystick_hasAxis(@intCast(c_uint, id), axis.toCSFML()) == c.sfTrue;
    }
    pub fn isButtonPressed(id: u32, button: u32) bool {
        return c.sfJoystick_isButtonPressed(@intCast(c_uint, id)) == c.sfTrue;
    }
    pub fn getAxisPosition(id: u32, axis: Axis) f32 {
        return c.sfJoystick_getAxisPosition(@intCast(c_uint, id), axis.toCSFML());
    }
    pub fn getIdentification(id: u32) Identification {
        return Identification.fromCSFML(c.sfJoystick_getIdentification(@intCast(c_uint, id)));
    }
    pub fn update() void {
        c.sfJoystick_update();
    }
};

pub const sensor = struct {
    pub const SensorType = extern enum(c_int) {
        accelerometer = c.sfSensorAccelerometer,
        gyroscope = c.sfSensorGyroscope,
        magnetometer = c.sfSensorMagnetometer,
        gravity = c.sfSensorGravity,
        user_acceleration = c.sfSensorUserAcceleration,
        sensor_orientation = c.sfSensorOrientation,

        pub fn toCSFML(self: SensorType) c.sfSensorType {
            return @intToEnum(c.sfSensorType, @enumToInt(self));
        }
        pub fn fromCSFML(other: c.sfSensorType) SensorType {
            return @intToEnum(SensorType, @enumToInt(other));
        }
    };
    pub const count = std.meta.fields(SensorType).len;

    pub fn isAvailable(sens: SensorType) bool {
        return c.sfSensor_isAvailable(sens.toCSFML());
    }
    pub fn setEnabled(sens: SensorType, enabled: bool) void {
        c.sfSensor_setEnabled(sens.toCSFML(), @boolToInt(enabled));
    }
    pub fn getValue(sens: SensorType) system.sfVector3f {
        return c.sfSensor_getValue(sens.toCSFML());
    }
};

pub const touch = struct {
    pub fn isDown(finger: u32) bool {
        return c.sfTouch_isDown(@intCast(c_uint, finger)) == c.sfTrue;
    }
    pub fn getPosition(finger: u32, relative_to: *const Window) system.Vector2i {
        return c.sfTouch_getPosition(@intCast(c_uint, finger), relative_to.internal);
    }
};

pub const event = struct {
    pub const EventType = extern enum(c_int) {
        closed = c.sfEvtClosed,
        resized = c.sfEvtResized,
        lost_focus = c.sfEvtLostFocus,
        gained_focus = c.sfEvtGainedFocus,
        text_entered = c.sfEvtTextEntered,
        key_pressed = c.sfEvtKeyPressed,
        key_released = c.sfEvtKeyReleased,
        mouse_wheel_scrolled = c.sfEvtMouseWheelScrolled,
        mouse_button_pressed = c.sfEvtMouseButtonPressed,
        mouse_button_released = c.sfEvtMouseButtonReleased,
        mouse_moved = c.sfEvtMouseMoved,
        mouse_entered = c.sfEvtMouseEntered,
        mouse_left = c.sfEvtMouseLeft,
        joystick_button_pressed = c.sfEvtJoystickButtonPressed,
        joystick_button_released = c.sfEvtJoystickButtonReleased,
        joystick_moved = c.sfEvtJoystickMoved,
        joystick_connected = c.sfEvtJoystickConnected,
        joystick_disconnected = c.sfEvtJoystickDisconnected,
        touch_began = c.sfEvtTouchBegan,
        touch_moved = c.sfEvtTouchMoved,
        touch_ended = c.sfEvtTouchEnded,
        sensor_changed = c.sfEvtSensorChanged,
        
        pub fn toCSFML(self: EventType) c.sfEventType {
            return @intToEnum(c.sfEventType, @enumToInt(self));
        }
        pub fn fromCSFML(evt: c.sfEventType) EventType {
            if (evt == @intToEnum(c.sfEventType, c.sfEvtMouseWheelMoved)) {
                @panic("sf::Event::MouseWheelEvent (sfMouseWheelEvent) unsupported");
            }
            return @intToEnum(EventType, @enumToInt(evt));
        }
    };

    pub const KeyEvent = struct {
        code: keyboard.Key,
        alt: bool,
        control: bool,
        shift: bool,
        system: bool,

        pub fn fromCSFML(csfml: c.sfKeyEvent) KeyEvent {
            return .{
                .code = keyboard.Key.fromCSFML(csfml.code),
                .alt = csfml.alt == c.sfTrue,
                .control = csfml.control == c.sfTrue,
                .shift = csfml.shift == c.sfTrue,
                .system = csfml.system == c.sfTrue,
            };
        }
        pub fn toCSFML(self: KeyEvent, evt_type: c.sfEventType) c.sfKeyEvent {
            return .{
                .@"type" = evt_type,
                .code = self.code.toCSFML(),
                .alt = if (self.alt) c.sfTrue else c.sfFalse,
                .control = if (self.control) c.sfTrue else c.sfFalse,
                .shift = if (self.shift) c.sfTrue else c.sfFalse,
                .system = if (self.system) c.sfTrue else c.sfFalse,
            };
        }
    };

    pub const TextEvent = struct {
        unicode: u32,

        pub fn fromCSFML(csfml: c.sfTextEvent) TextEvent {
            return .{
                .unicode = @intCast(u32, csfml.unicode),
            };
        }
        pub fn toCSFML(self: TextEvent, evt_type: c.sfEventType) c.sfTextEvent {
            return .{
                .@"type" = evt_type,
                .unicode = self.unicode,
            };
        }
    };

    pub const MouseMoveEvent = struct {
        x: i32,
        y: i32,

        pub fn fromCSFML(csfml: c.sfMouseMoveEvent) MouseMoveEvent {
            return .{
                .x = @intCast(i32, csfml.x),
                .y = @intCast(i32, csfml.y),
            };
        }
        pub fn toCSFML(self: MouseMoveEvent, evt_type: c.sfEventType) c.sfMouseMoveEvent {
            return .{
                .@"type" = evt_type,
                .x = @intCast(c_int, self.x),
                .y = @intCast(c_int, self.y),
            };
        }
    };

    pub const MouseButtonEvent = struct {
        button: mouse.Button,
        x: i32,
        y: i32,

        pub fn fromCSFML(csfml: c.sfMouseButtonEvent) MouseButtonEvent {
            return .{
                .button = mouse.Button.fromCSFML(csfml.button),
                .x = @intCast(i32, csfml.x),
                .y = @intCast(i32, csfml.y),
            };
        }
        pub fn toCSFML(self: MouseButtonEvent, evt_type: c.sfEventType) c.sfMouseButtonEvent {
            return .{
                .@"type" = evt_type,
                .button = self.button.toCSFML(),
                .x = @intCast(c_int, self.x),
                .y = @intCast(c_int, self.y),
            };
        }
    };

    pub const MouseWheelScrollEvent = struct {
        wheel: mouse.Wheel,
        delta: f32,
        x: i32,
        y: i32,

        pub fn fromCSFML(csfml: c.sfMouseWheelScrollEvent) MouseWheelScrollEvent {
            return .{
                .wheel = mouse.Wheel.fromCSFML(csfml.wheel),
                .delta = csfml.delta,
                .x = @intCast(i32, csfml.x),
                .y = @intCast(i32, csfml.y),
            };
        }
        pub fn toCSFML(self: MouseWheelScrollEvent, evt_type: c.sfEventType) c.sfMouseWheelScrollEvent {
            return .{
                .@"type" = evt_type,
                .wheel = self.wheel.toCSFML(),
                .delta = self.delta,
                .x = @intCast(c_int, self.x),
                .y = @intCast(c_int, self.y),
            };
        }
    };

    pub const JoystickMoveEvent = struct {
        joystick_id: u32,
        axis: joystick.Axis,
        position: f32,

        pub fn fromCSFML(csfml: c.sfJoystickMoveEvent) JoystickMoveEvent {
            return .{
                .joystick_id = @intCast(u32, csfml.joystickId),
                .axis = joystick.Axis.fromCSFML(csfml.axis),
                .position = csfml.position,
            };
        }
        pub fn toCSFML(self: JoystickMoveEvent, evt_type: c.sfEventType) c.sfJoystickMoveEvent {
            return .{
                .@"type" = evt_type,
                .joystickId = @intCast(c_uint, self.joystick_id),
                .axis = self.axis.toCSFML(),
                .position = self.position,
            };
        }
    };

    pub const JoystickButtonEvent = struct {
        joystick_id: u32,
        button: u32,

        pub fn fromCSFML(csfml: c.sfJoystickButtonEvent) JoystickButtonEvent {
            return .{
                .joystick_id = @intCast(u32, csfml.joystickId),
                .button = @intCast(u32, csfml.button),
            };
        }
        pub fn toCSFML(self: JoystickButtonEvent, evt_type: c.sfEventType) c.sfJoystickButtonEvent {
            return .{
                .@"type" = evt_type,
                .joystickId = @intCast(c_uint, self.joystick_id),
                .button = @intCast(c_uint, self.button),
            };
        }
    };

    pub const JoystickConnectEvent = struct {
        joystick_id: u32,

        pub fn fromCSFML(csfml: c.sfJoystickConnectEvent) JoystickConnectEvent {
            return .{
                .joystick_id = @intCast(u32, csfml.joystickId),
            };
        }
        pub fn toCSFML(self: JoystickConnectEvent, evt_type: c.sfEventType) c.sfJoystickConnectEvent {
            return .{
                .@"type" = evt_type,
                .joystickId = @intCast(c_uint, self.joystick_id),
            };
        }
    };

    pub const SizeEvent = struct {
        width: u32,
        height: u32,

        pub fn fromCSFML(csfml: c.sfSizeEvent) SizeEvent {
            return .{
                .width = @intCast(u32, csfml.width),
                .height = @intCast(u32, csfml.height),
            };
        }
        pub fn toCSFML(self: SizeEvent, evt_type: c.sfEventType) c.sfSizeEvent {
            return .{
                .@"type" = evt_type,
                .width = @intCast(c_uint, self.width),
                .height = @intCast(c_uint, self.height),
            };
        }
    };

    pub const TouchEvent = struct {
        finger: u32,
        x: i32,
        y: i32,

        pub fn fromCSFML(csfml: c.sfTouchEvent) TouchEvent {
            return .{
                .finger = @intCast(u32, csfml.finger),
                .x = @intCast(i32, csfml.x),
                .y = @intCast(i32, csfml.y),
            };
        }
        pub fn toCSFML(self: TouchEvent, evt_type: c.sfEventType) c.sfTouchEvent {
            return .{
                .@"type" = evt_type,
                .finger = @intCast(c_uint, self.finger),
                .x = @intCast(c_int, self.x),
                .y = @intCast(c_int, self.y),
            };
        }
    };

    pub const SensorEvent = struct {
        sensor_type: sensor.SensorType,
        x: f32,
        y: f32,
        z: f32,

        pub fn fromCSFML(csfml: c.sfSensorEvent) SensorEvent {
            return .{
                .sensor_type = sensor.SensorType.fromCSFML(csfml.sensorType),
                .x = csfml.x,
                .y = csfml.y,
                .z = csfml.z,
            };
        }
        pub fn toCSFML(self: SensorEvent, evt_type: c.sfEventType) c.sfSensorEvent {
            return .{
                .@"type" = evt_type,
                .sensorType = self.sensor_type.toCSFML(),
                .x = self.x,
                .y = self.y,
                .z = self.z,
            };
        }
    };

    pub const Event = union(EventType) {
        closed: void,
        resized: SizeEvent,
        lost_focus: void,
        gained_focus: void,
        text_entered: TextEvent,
        key_pressed: KeyEvent,
        key_released: KeyEvent,
        mouse_wheel_scrolled: MouseWheelScrollEvent,
        mouse_button_pressed: MouseButtonEvent,
        mouse_button_released: MouseButtonEvent,
        mouse_moved: MouseMoveEvent,
        mouse_entered: void,
        mouse_left: void,
        joystick_button_pressed: JoystickButtonEvent,
        joystick_button_released: JoystickButtonEvent,
        joystick_moved: JoystickMoveEvent,
        joystick_connected: JoystickConnectEvent,
        joystick_disconnected: JoystickConnectEvent,
        touch_began: TouchEvent,
        touch_moved: TouchEvent,
        touch_ended: TouchEvent,
        sensor_changed: SensorEvent,

        pub fn fromCSFML(evt: c.sfEvent) Event {
            return switch (EventType.fromCSFML(evt.@"type")) {
                .closed => .{ .closed = {} },
                .resized => .{ .resized = SizeEvent.fromCSFML(evt.size) },
                .lost_focus => .{ .lost_focus = {} },
                .gained_focus => .{ .gained_focus = {} },
                .text_entered => .{ .text_entered = TextEvent.fromCSFML(evt.text) },
                .key_pressed => .{ .key_pressed = KeyEvent.fromCSFML(evt.key) },
                .key_released => .{ .key_released = KeyEvent.fromCSFML(evt.key) },
                .mouse_wheel_scrolled => .{ .mouse_wheel_scrolled = MouseWheelScrollEvent.fromCSFML(evt.mouseWheelScroll) },
                .mouse_button_pressed => .{ .mouse_button_pressed = MouseButtonEvent.fromCSFML(evt.mouseButton) },
                .mouse_button_released => .{ .mouse_button_released = MouseButtonEvent.fromCSFML(evt.mouseButton) },
                .mouse_moved => .{ .mouse_moved = MouseMoveEvent.fromCSFML(evt.mouseMove) },
                .mouse_entered => .{ .mouse_entered = {} },
                .mouse_left => .{ .mouse_left = {} },
                .joystick_button_pressed => .{ .joystick_button_pressed = JoystickButtonEvent.fromCSFML(evt.joystickButton) },
                .joystick_button_released => .{ .joystick_button_released = JoystickButtonEvent.fromCSFML(evt.joystickButton) },
                .joystick_moved => .{ .joystick_moved = JoystickMoveEvent.fromCSFML(evt.joystickMove) },
                .joystick_connected => .{ .joystick_connected = JoystickConnectEvent.fromCSFML(evt.joystickConnect) },
                .joystick_disconnected => .{ .joystick_disconnected = JoystickConnectEvent.fromCSFML(evt.joystickConnect) },
                .touch_began => .{ .touch_began = TouchEvent.fromCSFML(evt.touch) },
                .touch_moved => .{ .touch_moved = TouchEvent.fromCSFML(evt.touch) },
                .touch_ended => .{ .touch_ended = TouchEvent.fromCSFML(evt.touch) },
                .sensor_changed => .{ .sensor_changed = SensorEvent.fromCSFML(evt.sensor) },
            };
        }
        pub fn toCSFML(self: Event) c.sfEvent {
            const evt_type = @as(EventType, self).toCSFML();
            return switch (self) {
                .closed => .{ .@"type" = evt_type },
                .lost_focus => .{ .@"type" = evt_type },
                .gained_focus => .{ .@"type" = evt_type },
                .mouse_entered => .{ .@"type" = evt_type },
                .mouse_left => .{ .@"type" = evt_type },
                .resized => |e| .{ .size = e.toCSFML(evt_type) },
                .text_entered => |e| .{ .text = e.toCSFML(evt_type) },
                .key_pressed => |e| .{ .key = e.toCSFML(evt_type) },
                .key_released => |e| .{ .key = e.toCSFML(evt_type) },
                .mouse_wheel_scrolled => |e| .{ .mouseWheelScroll = e.toCSFML(evt_type) },
                .mouse_button_pressed => |e| .{ .mouseButton = e.toCSFML(evt_type) },
                .mouse_button_released => |e| .{ .mouseButton = e.toCSFML(evt_type) },
                .mouse_moved => |e| .{ .mouseMove = e.toCSFML(evt_type) },
                .joystick_button_pressed => |e| .{ .joystickButton = e.toCSFML(evt_type) },
                .joystick_button_released => |e| .{ .joystickButton = e.toCSFML(evt_type) },
                .joystick_moved => |e| .{ .joystickMove = e.toCSFML(evt_type) },
                .joystick_connected => |e| .{ .joystickConnect = e.toCSFML(evt_type) },
                .joystick_disconnected => |e| .{ .joystickConnect = e.toCSFML(evt_type) },
                .touch_began => |e| .{ .touch = e.toCSFML(evt_type) },
                .touch_moved => |e| .{ .touch = e.toCSFML(evt_type) },
                .touch_ended => |e| .{ .touch = e.toCSFML(evt_type) },
                .sensor_changed => |e| .{ .sensor = e.toCSFML(evt_type) },
            };
        }
    };
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
    depth_bits: u32 = 0,
    stencil_bits: u32 = 0,
    antialiasing_level: u32 = 0,
    major_version: u32 = 1,
    minor_version: u32 = 1,
    attribute_flags: u32 = Window.context_attribute.default,
    srgb_capable: bool = false,

    pub fn fromCSFML(cs: c.sfContextSettings) ContextSettings {
        return .{
            .depth_bits = @intCast(u32, cs.depthBits),
            .stencil_bits = @intCast(u32, cs.stencilBits),
            .antialiasing_level = @intCast(u32, cs.antialiasingLevel),
            .major_version = @intCast(u32, cs.majorVersion),
            .minor_version = @intCast(u32, cs.minorVersion),
            .attribute_flags = cs.attributeFlags,
            .srgb_capable = cs.sRgbCapable == c.sfTrue,
        };
    }

    pub fn toCSFML(self: *const ContextSettings) c.sfContextSettings {
        return .{
            .depthBits = @intCast(c_uint, self.depth_bits),
            .stencilBits = @intCast(c_uint, self.stencil_bits),
            .antialiasingLevel = @intCast(c_uint, self.antialiasing_level),
            .majorVersion = @intCast(c_uint, self.major_version),
            .minorVersion = @intCast(c_uint, self.minor_version),
            .attributeFlags = self.attribute_flags,
            .sRgbCapable = @boolToInt(self.srgb_capable),
        };
    }
};

pub const Cursor = struct {
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

        pub fn toCSFML(self: CursorType) c.sfCursorType {
            return @intToEnum(c.sfCursorType, @enumToInt(self));
        }
        pub fn fromCSFML(evt: c.sfCursorType) CursorType {
            return @intToEnum(CursorType, @enumToInt(evt));
        }
    };

    internal: *c.sfCursor,

    pub fn createFromPixels(pixels: []const u8, size: system.Vector2u, hotspot: system.Vector2u) !Cursor {
        std.debug.assert(pixels.len == size.x * size.y);
        return Cursor{
            .internal = c.sfCursor_createFromPixels(pixels.ptr, size, hotspot) orelse return error.SfmlError,
        };
    }
    pub fn createFromSystem(t: CursorType) !Cursor {
        return Cursor{
            .internal = c.sfCursor_createFromSystem(t.toCSFML()) orelse return error.SfmlError,
        };
    }
    pub fn destroy(self: *Cursor) void {
        c.sfCursor_destroy(self.internal);
    }
};

pub const VideoMode = struct {
    width: u32,
    height: u32,
    bits_per_pixel: u32,

    pub fn init(w: u32, h: u32, bpp: u32) VideoMode {
        return .{ .width = w, .height = h, .bits_per_pixel = bpp };
    }

    pub fn fromCSFML(csfml: c.sfVideoMode) VideoMode {
        return .{
            .width = @intCast(u32, csfml.width),
            .height = @intCast(u32, csfml.height),
            .bits_per_pixel = @intCast(u32, csfml.bitsPerPixel),
        };
    }
    pub fn toCSFML(self: VideoMode) c.sfVideoMode {
        return .{
            .width = @intCast(c_uint, self.width),
            .height = @intCast(c_uint, self.height),
            .bitsPerPixel = @intCast(c_uint, self.bits_per_pixel),
        };
    }

    pub fn getDesktopMode() VideoMode {
        return fromCSFML(c.sfVideoMode_getDesktopMode());
    }
    pub fn getFullscreenModes(allocator: *std.mem.Allocator) ![]VideoMode {
        var mode_count: usize = undefined;
        var modes = c.sfVideoMode_getFullscreenModes(&mode_count);
        var result = try allocator.alloc(VideoMode, mode_count);
        var i: usize = 0;
        while (i < mode_count) : (i += 1) {
            result[i] = fromCSFML(modes[i]);
        }
        return result;
    }
    pub fn isValid(mode: VideoMode) bool {
        return c.sfVideoMode_isValid(mode.toCSFML()) == c.sfTrue;
    }
};

pub const WindowHandle = c.sfWindowHandle;

pub const Window = struct {
    pub const style = struct {
        pub const none = @intCast(u32, c.sfNone);
        pub const titlebar = @intCast(u32, c.sfTitlebar);
        pub const resize = @intCast(u32, c.sfResize);
        pub const close = @intCast(u32, c.sfClose);
        pub const fullscreen = @intCast(u32, c.sfFullscreen);
        pub const default = @intCast(u32, c.sfDefaultStyle);
    };

    pub const context_attribute = struct {
        pub const default = @intCast(u32, c.sfContextDefault);
        pub const core = @intCast(u32, c.sfContextCore);
        pub const debug = @intCast(u32, c.sfContextDebug);
    };

    internal: *c.sfWindow,

    pub fn create(
        mode: VideoMode,
        title: []const u8,
        style_flags: u32,
        settings: *const ContextSettings
    ) !Window {
        const string = try sfml.allocator.dupeZ(u8, title);
        defer sfml.allocator.free(string);
        const internal = c.sfWindow_create(
            mode.toCSFML(),
            string,
            style_flags,
            &settings.toCSFML(),
        ) orelse return error.SfmlError;
        return Window{ .internal = internal };
    }
    
    // TODO: write implementations for functions below
    pub fn createUnicode(
        mode: VideoMode,
        title: []const u32,
        style_flags: u32,
        settings: *const ContextSettings
    ) !Window {
        const string = try sfml.allocator.dupeZ(u32, title);
        defer sfml.allocator.free(string);
        const internal = c.sfWindow_createUnicode(
            mode.toCSFML(),
            string,
            style_flags,
            settings.toCSFML(),
        ) orelse return error.SfmlError;
        return Window{ .internal = internal };
    }

    pub fn createFromHandle(handle: WindowHandle, settings: *const ContextSettings) !Window {
        return Window{
            .internal = c.sfWindow_createFromHandle(handle, settings.toCSFML()) orelse return error.SfmlError,
        };
    }
    pub fn destroy(self: *Window) void {
        c.sfWindow_destroy(self.internal);
    }
    pub fn close(self: *Window) void {
        c.sfWindow_close(self.internal);
    }
    pub fn isOpen(self: *Window) bool {
        return c.sfWindow_isOpen(self.internal) == c.sfTrue;
    }
    pub fn getSettings(self: *const Window) ContextSettings {
        return ContextSettings.fromCSFML(c.sfWindow_getSettings(self.internal));
    }
    pub fn pollEvent(self: *Window, evt: *event.Event) bool {
        var cevt: c.sfEvent = undefined;
        var result: bool = false;
        while (self.isOpen()) {
            result = c.sfWindow_pollEvent(self.internal, &cevt) == c.sfTrue;
            // This invalid event can sometimes be sent through the event queue
            // It's not a valid event therefore it causes a crash.
            // Ignoring it *seems* to make it work.
            if (@enumToInt(cevt.@"type") == -1431655766) continue;
            evt.* = event.Event.fromCSFML(cevt);
            break;
        }
        return result;
    }
    pub fn waitEvent(self: *Window, evt: *event.Event) bool {
        var cevt: c.sfEvent = undefined;
        var result: bool = false;
        while (self.isOpen()) {
            result = c.sfWindow_waitEvent(self.internal, &cevt) == c.sfTrue;
            // This invalid event can sometimes be sent through the event queue
            // It's not a valid event therefore it causes a crash.
            // Ignoring it *seems* to make it work.
            if (@enumToInt(cevt.@"type") == -1431655766) continue;
            evt.* = event.Event.fromCSFML(cevt);
            break;
        }
        return result;
    }
    pub fn getPosition(self: *const Window) system.Vector2i {
        return c.sfWindow_getPosition(self.internal);
    }
    pub fn setPosition(self: *Window, position: system.Vector2i) void {
        c.sfWindow_setPosition(self.internal, position);
    }
    pub fn getSize(self: *const Window) system.Vector2u {
        return c.sfWindow_getSize(self.internal);
    }
    pub fn setSize(self: *Window, size: system.Vector2u) void {
        c.sfWindow_setSize(self.internal, size);
    }
    pub fn setTitle(self: *Window, title: []const u8) void {
        const string = try sfml.allocator.dupeZ(u8, title);
        defer sfml.allocator.free(string);
        c.sfWindow_setTitle(self.internal, string);
    }
    pub fn setUnicodeTitle(self: *Window, title: []const u32) void {
        const string = try sfml.allocator.dupeZ(u32, title);
        defer sfml.allocator.free(string);
        c.sfWindow_setTitle(self.internal, string);
    }
    pub fn setIcon(self: *Window, w: u32, h: u32, pixels: []const u8) void {
        std.debug.assert(pixels.len == w * h * 4);
        c.sfWindow_setIcon(
            self.internal,
            @intCast(c_uint, w),
            @intCast(c_uint, h),
            @ptrCast([*c]c.sfUint8, pixels.ptr),
        );
    }
    pub fn setVisible(self: *Window, visible: bool) void {
        c.sfWindow_setVisible(self.internal, @boolToInt(visible));
    }
    pub fn setVerticalSyncEnabled(self: *Window, enabled: bool) void {
        c.sfWindow_setVerticalSyncEnabled(self.internal, @boolToInt(enabled));
    }
    pub fn setMouseCursorVisible(self: *Window, visible: bool) void {
        c.sfWindow_setMouseCursorVisible(self.internal, @boolToInt(enabled));
    }
    pub fn setMouseCursorGrabbed(self: *Window, grabbed: bool) void {
        c.sfWindow_setMouseCursorGrabbed(self.internal, @boolToInt(enabled));
    }
    pub fn setMouseCursor(self: *Window, cursor: *const Cursor) void {
        c.sfWindow_setMouseCursor(self.internal, cursor.internal);
    }
    pub fn setKeyRepeatEnabled(self: *Window, enabled: bool) void {
        c.sfWindow_setKeyRepeatEnabled(self.internal, @boolToInt(enabled));
    }
    pub fn setFramerateLimit(self: *Window, limit: u32) void {
        c.sfWindow_setFramerateLimit(self.internal, @intCast(c_uint, limit));
    }
    pub fn setJoystickThreshold(self: *Window, threshold: f32) void {
        c.sfWindow_setJoystickThreshold(self.internal, threshold);
    }
    pub fn setActive(self: *Window, active: bool) bool {
        return c.sfWindow_setActive(self.internal, @boolToInt(enabled)) == c.sfTrue;
    }
    pub fn requestFocus(self: *Window) void {
        c.sfWindow_requestFocus(self.internal);
    }
    pub fn hasFocus(self: *const Window) bool {
        return c.sfWindow_hasFocus(self.internal) == c.sfTrue;
    }
    pub fn display(self: *Window) void {
        c.sfWindow_display(self.internal);
    }
    pub fn getSystemHandle(self: *const Window) WindowHandle {
        return c.sfWindow_getSystemHandle(self.internal);
    }
};

const std = @import("std");
const sfml = @import("sfml");

usingnamespace sfml.window;

pub fn main() !void {
    var win = try Window.create(
        VideoMode.init(640, 480, 24),
        "Trans rights",
        Window.style.default,
        &ContextSettings{}
    );
    defer win.destroy();
    
    win.setVerticalSyncEnabled(true);
    win.display();
    while (win.isOpen()) {
        var evt: event.Event = undefined;
        while (win.pollEvent(&evt)) {
            switch (evt) {
                .closed => win.close(),
                else => {},
            }
        }
        win.display();
    }
}

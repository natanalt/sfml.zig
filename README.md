# sfml.zig
Simple binding of [SFML](https://www.sfml-dev.org) to Zig, using CSFML internally.

## Usage
Add the package to your project, like this:
```zig
exe.addPackagePath("sfml", "path/to/this/repos/src/sfml.zig");
```
Now you can do `@import("sfml")` and use this library. You also have to link the libraries you'll use, including libc:
```zig
exe.linkSystemLibrary("csfml-system");
exe.linkSystemLibrary("csfml-window");
exe.linkSystemLibrary("csfml-graphics");
exe.linkSystemLibrary("csfml-audio");
exe.linkSystemLibrary("csfml-network");
exe.linkLibC();
```

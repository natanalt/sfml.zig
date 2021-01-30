# sfml.zig
Simple binding of [SFML](https://www.sfml-dev.org) to Zig, using CSFML internally.

It tries to mimic the C++ SFML API as much as possible, while also staying within Zig style guidelines.
There's no documentation yet, and you'll have to guess names of APIs (they should at least *somehow* map into the [SFML API docs](https://www.sfml-dev.org/documentation/2.5.1/annotated.php), you can also read the code I guess)

## Usage
Add the package to your project, like this:
```zig
exe.addPackagePath("sfml", "path/to/this/repos/src/sfml.zig");
```
(Entire single file versions of sfml.zig might be available someday)
Now you can do `@import("sfml")` and use the library. You also have to link the libraries you'll use, including libc:
```zig
exe.linkSystemLibrary("csfml-system");
exe.linkSystemLibrary("csfml-window");
exe.linkSystemLibrary("csfml-graphics");
exe.linkSystemLibrary("csfml-audio");
exe.linkSystemLibrary("csfml-network");
exe.linkLibC();

// If you've installed CSFML using a package manager on Linux, there's a chance the headers are installed at
// /usr/include and should be visible to the compiler without adding explicit include paths. Same goes for library paths
//
// If you're building on Windows and/or above is not a thing for you, you'll have to add necessary include and library
// paths yourself. It's left as an exercise to the reader ^^
exe.addIncludeDir("path/to/sfml/include");
exe.addLibPath("path/to/sfml/lib");
```
Static linking of SFML is possible, but it's a bit more complicated. The official SFML website should have some guides on that, which could be adaptable to the Zig build system.

## Internal allocator usage
While SFML itself just uses the C++ standard library allocator, the bindings sometimes want to allocate something by themselves. Most required allocations are reallocations of strings to include a NULL byte at the end to please the standard. In this case, the libc allocator is used by default. It can be configured by defining `sfml_zig_allocator` declaration in the root source file.

Is this against what Zig code ought to usually do? Yes. But I consider it to be a better choice in this case.

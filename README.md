# Build

This project has the following dependencies

* cimgui as git submodule (in which it has imgui as dependencies as git submodule the same)

Before building, execute `git submodule update --init` to clone down all dependencies from git submodules.

You have 3 options

* `make` or `make all` - to build both variant with `gl3w` and `glew` as loader
* `make gl3w`
* `make glew`

Then run newly built `main-gl3w` or `main-glew` depends on which make's target you've executed.

# Note

- With help of suggestion from [#78](https://github.com/cimgui/cimgui/issues/78), and [#79](https://github.com/cimgui/cimgui/issues/79).
- Tested on macOS only, for Windows and Linux will need slight modification on `Makefile` file

# More Info

My blog post about accompnaying this project for more detail [Integrate cimgui with SDL2 in C code](https://blog.wasin.io/2018/10/31/integrate-cimgui-with-sdl2-in-c-code.html).

# License
[MIT](https://github.com/haxpor/sdl2-cimgui-demo/blob/master/LICENSE.txt), Wasin Thonkaew

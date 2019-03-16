CFLAGS = -Wall -std=c99 -I./gl3w/include -I/opt/X11/include -I./imgui -I./imgui/impl -I. -I/usr/local/include/SDL2 -g -DIMGUI_IMPL_API=""
CFLAGS_GLEW = -Wall -std=c99 -I/opt/X11/include -I./imgui -I./imgui/impl -I. -I/usr/local/include/SDL2 -g -DIMGUI_IMPL_OPENGL_LOADER_GLEW -DIMGUI_IMPL_API=""
LFLAGS = -lSDL2 -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo -L./ cimgui.dylib -lc++ `sdl2-config --libs`
LFLAGS_GLEW = -lSDL2 -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo -L./ cimgui.dylib -lGLEW -lc++ `sdl2-config --libs`

SDL_IMPL_CFLAGS = -I. -I./imgui -I/opt/X11/include -I/usr/local/include/SDL2 -I/usr/local/include/GL -I/opt/local/include -DIMGUI_IMPL_API="extern \"C\""
OPENGL3_IMPL_CFLAGS = -I. -I./gl3w/include -I./imgui -I/usr/local/include/GL -DIMGUI_IMPL_API="extern \"C\"" 
OPENGL3_IMPL_CFLAGS_GLEW = -I. -I./imgui -I/usr/local/include/GL -DIMGUI_IMPL_API="extern \"C\"" -DIMGUI_IMPL_OPENGL_LOADER_GLEW

IMGUI_IMPL_DIR = imgui/impl
GL3W_DIR = gl3w

OBJS_GL3W = \
	    imgui_impl_sdl.o \
	    imgui_impl_opengl3.o \
	    main.o \
	    main

OBJS_GLEW = \
	    imgui_impl_sdl.o \
	    imgui_impl_opengl3.o_glew \
	    main.o_glew \
	    main_glew

.PHONY: all glew clean

all: $(OBJS_GL3W)

glew: $(OBJS_GLEW)

main: main.o gl3w.o imgui_impl_sdl.o imgui_impl_opengl3.o
	gcc main.o $(IMGUI_IMPL_DIR)/imgui_impl_sdl.o $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.o $(GL3W_DIR)/src/gl3w.o -o main $(LFLAGS)

main_glew: main.o_glew imgui_impl_sdl.o imgui_impl_opengl3.o_glew
	gcc main.o $(IMGUI_IMPL_DIR)/imgui_impl_sdl.o $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.o -o main $(LFLAGS_GLEW)

imgui_impl_sdl.o: $(IMGUI_IMPL_DIR)/imgui_impl_sdl.cpp $(IMGUI_IMPL_DIR)/imgui_impl_sdl.h
	g++ $(SDL_IMPL_CFLAGS) -c $< -o $(IMGUI_IMPL_DIR)/$@

imgui_impl_opengl3.o: $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.cpp $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.h
	g++ $(OPENGL3_IMPL_CFLAGS) -c $< -o $(IMGUI_IMPL_DIR)/$@

imgui_impl_opengl3.o_glew: $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.cpp $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.h
	g++ $(OPENGL3_IMPL_CFLAGS_GLEW) -c $< -o $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.o

gl3w.o: gl3w/src/gl3w.c gl3w/include/GL/gl3w.h gl3w/include/GL/glcorearb.h
	gcc $(CFLAGS) -c $< -o gl3w/src/$@

main.o: main.c
	gcc $(CFLAGS) -c $< -o $@

main.o_glew: main.c
	gcc $(CFLAGS_GLEW) -c $< -o main.o

clean:
	rm -rf *.o
	rm -rf main
	rm -rf $(IMGUI_IMPL_DIR)/*.o
	rm -rf $(GL3W_DIR)/src/*.o

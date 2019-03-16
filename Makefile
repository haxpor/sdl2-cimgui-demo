# two variants build here are defined
# 1. gl32
# 2. glew
#
# `make` will proceed with 1. But `make glew` will proceed with 2.
# So watch out for _GLEW varaint in this Makefile.
#
# Provided 3 targets
# 1. all - both gl3w, and glew
# 2. gl3w
# 3. glew
#

CC := gcc
INCLDIR := externals/cimgui
SRCDIR := src
SDL2_INCLDIR := /usr/local/include/SDL2
GL3W_INCLDIR := gl3w/include
GLEW_INCLDIR := /usr/local/include/GL
IMGUI_INCLDIR := externals/cimgui/imgui
IMGUI_IMPL_INCLDIR := imgui/impl
IMGUI_IMPL_DIR := imgui/impl
GL3W_DIR := gl3w
OUT_GL3W := main-gl3w
OUT_GLEW := main-glew

UNAME_S := $(shell uname -s)

# different file extension on different platform
# for cimgui library after building
ifeq ($(UNAME_S), Linux) #LINUX
	CIMGUI_LIB := cimgui.so
endif

ifeq ($(UNAME_S), Darwin) #APPLE
	CIMGUI_LIB := cimgui.dylib
endif

ifeq ($(UNAME_S), Windows_NT) #WINDOWS
	CIMGUI_LIB := cimgui.dll
endif

CFLAGS := -Wall -std=c99 -Igl3w/include -I/opt/X11/include -I$(IMGUI_INCLDIR) -I$(IMGUI_IMPL_INCLDIR) -I$(INCLDIR) -I$(SDL2_INCLDIR) -g -DIMGUI_IMPL_OPENGL_LOADER_GL3W -DIMGUI_IMPL_API=""
CFLAGS_GLEW := -Wall -std=c99 -I/opt/X11/include -I$(IMGUI_INCLDIR) -I$(IMGUI_IMPL_INCLDIR) -I$(INCLDIR) -I$(SDL2_INCLDIR) -g -DIMGUI_IMPL_OPENGL_LOADER_GLEW -DIMGUI_IMPL_API=""
LFLAGS := -lSDL2 -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo $(CIMGUI_LIB) -lc++
LFLAGS_GLEW := -lSDL2 -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo $(CIMGUI_LIB) -lGLEW -lc++

SDL_IMPL_CFLAGS = -I$(INCLDIR) -I$(IMGUI_INCLDIR) -I$(IMGUI_IMPL_INCLDIR) -I/opt/X11/include -I$(SDL2_INCLDIR) -I$(GLEW_INCLDIR) -DIMGUI_IMPL_API="extern \"C\""
OPENGL3_IMPL_CFLAGS = -I$(INCLDIR) -Igl3w/include -I$(IMGUI_INCLDIR) -I$(IMGUI_IMPL_INCLDIR) -DIMGUI_IMPL_API="extern \"C\"" 
OPENGL3_IMPL_CFLAGS_GLEW = -I$(INCLDIR) -I$(IMGUI_INCLDIR) -I$(IMGUI_IMPL_INCLDIR) -I$(GLEW_INCLDIR) -DIMGUI_IMPL_API="extern \"C\"" -DIMGUI_IMPL_OPENGL_LOADER_GLEW

OBJS_GL3W = \
	    cimgui	\
	    imgui_impl_sdl.o \
	    imgui_impl_opengl3.o \
	    main.o \
	    main

OBJS_GLEW = \
	    cimgui	\
	    imgui_impl_sdl.o \
	    imgui_impl_opengl3.o_glew \
	    main_glew.o \
	    main_glew

.PHONY: all glew gl3w clean

all: $(OBJS_GL3W) $(OBJS_GLEW)

gl3w: $(OBJS_GL3W)

glew: $(OBJS_GLEW)

main: main.o gl3w.o imgui_impl_sdl.o imgui_impl_opengl3.o cimgui
	gcc $(SRCDIR)/main.o $(IMGUI_IMPL_DIR)/imgui_impl_sdl.o $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.o $(GL3W_DIR)/src/gl3w.o -o $(OUT_GL3W) $(LFLAGS)

main_glew: main_glew.o imgui_impl_sdl.o imgui_impl_opengl3.o_glew cimgui
	gcc $(SRCDIR)/main_glew.o $(IMGUI_IMPL_DIR)/imgui_impl_sdl.o $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.o -o $(OUT_GLEW) $(LFLAGS_GLEW)

imgui_impl_sdl.o: $(IMGUI_IMPL_DIR)/imgui_impl_sdl.cpp $(IMGUI_IMPL_DIR)/imgui_impl_sdl.h
	g++ $(SDL_IMPL_CFLAGS) -c $< -o $(IMGUI_IMPL_DIR)/$@

imgui_impl_opengl3.o: $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.cpp $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.h
	g++ $(OPENGL3_IMPL_CFLAGS) -c $< -o $(IMGUI_IMPL_DIR)/$@

imgui_impl_opengl3.o_glew: $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.cpp $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.h
	g++ $(OPENGL3_IMPL_CFLAGS_GLEW) -c $< -o $(IMGUI_IMPL_DIR)/imgui_impl_opengl3.o

gl3w.o: gl3w/src/gl3w.c gl3w/include/GL/gl3w.h gl3w/include/GL/glcorearb.h
	gcc $(CFLAGS) -c $< -o gl3w/src/$@

main.o: $(SRCDIR)/main.c
	gcc $(CFLAGS) -c $< -o $(SRCDIR)/$@

main_glew.o: $(SRCDIR)/main.c
	gcc $(CFLAGS_GLEW) -c $< -o $(SRCDIR)/$@

cimgui:
	make -C externals/cimgui
	cp -p externals/cimgui/$(CIMGUI_LIB) ./

clean:
	rm -f $(SRCDIR)/*.o
	rm -f $(IMGUI_IMPL_DIR)/*.o
	rm -f $(GL3W_DIR)/src/*.o
	rm -f $(OUT_GL3W)
	rm -f $(OUT_GLEW)

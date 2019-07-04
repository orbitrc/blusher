OBJ = Application_bridge.o \
	Application.o

default: $(OBJ)
	$(CC) -shared -Wl,-soname,libblusher.so.0 -Iinclude -o lib/libblusher.so.0.1.0 $^ -lQt5Quick -lQt5Gui -lQt5Qml -lQt5Network -lQt5Core /usr/lib/libGL.so -lpthread

Application.o: src/Application.c
	$(CC) -c -Iinclude -fPIC $^ -o $@

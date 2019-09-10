OBJ = Application_bridge.o \
	Application.o

VERSION = "0.1.0-alpha1"

default: lib
	echo "default: Make libraries."

lib: $(OBJ)
	$(CC) -shared -Wl,-soname,libblusher.so.0 -Iinclude -o lib/libblusher.so.0.1.0 $^ -lQt5Quick -lQt5Gui -lQt5Qml -lQt5Network -lQt5Core /usr/lib/libGL.so -lpthread

install:
	rm -rf /usr/lib/blusher
	cp -r lib/blusher /usr/lib/blusher

dist: lib
	rm -rf blusher_$(VERSION)
	mkdir blusher_$(VERSION)
	cp -r lib blusher_$(VERSION)
	tar cvf blusher_$(VERSION).tar blusher_$(VERSION)
	gzip blusher_$(VERSION).tar

clean:
	rm -rf lib/libblusher.so*

Application.o: src/Application.c
	$(CC) -c -Iinclude -fPIC $^ -o $@

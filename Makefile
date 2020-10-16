include Makefile.base

default:
	mkdir -p build
	cd build && $(QMAKE) ../blusher.pro -spec linux-g++ && make qmake_all
	cd build && make -j8
	cp build/libblusher.so.$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH) $(QML_PLUGIN_DIR)/libblusher.so

debug:
	mkdir -p debug
	cd debug && $(QMAKE) ../blusher.pro -spec linux-g++ CONFIG+=debug && make qmake_all
	cd debug && make -j8
	cp debug/libblusher.so.$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH) $(QML_PLUGIN_DIR)/libblusher.so

install:
	rm -rf /usr/lib/blusher
	cp -r lib/blusher /usr/lib/blusher
	rm -rf /usr/include/blusher
	cp -r include/blusher /usr/include/blusher

clean:
	rm -rf build
	rm -rf debug
	rm -f $(QML_PLUGIN_DIR)/libblusher.so

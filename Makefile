include Makefile.base

default:
	mkdir -p build
	cd build && $(QMAKE) ../blusher.pro -spec linux-g++ && make qmake_all
	cd build && make -j8
	cp build/libblusher.so.$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH) $(SHARED_LIB_TARGET_DIR)
	rm -f $(SHARED_LIB_TARGET_DIR)/libblusher.so.$(VERSION_MAJOR).$(VERSION_MINOR)
	ln -s libblusher.so.$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH) $(SHARED_LIB_TARGET_DIR)/libblusher.so.$(VERSION_MAJOR).$(VERSION_MINOR)
	rm -f $(SHARED_LIB_TARGET_DIR)/libblusher.so.$(VERSION_MAJOR)
	ln -s libblusher.so.$(VERSION_MAJOR).$(VERSION_MINOR) $(SHARED_LIB_TARGET_DIR)/libblusher.so.$(VERSION_MAJOR)
	rm -f $(SHARED_LIB_TARGET_DIR)/libblusher.so
	ln -s libblusher.so.$(VERSION_MAJOR) $(SHARED_LIB_TARGET_DIR)/libblusher.so

debug:
	mkdir -p debug
	cd debug && $(QMAKE) ../blusher.pro -spec linux-g++ CONFIG+=debug && make qmake_all
	cd debug && make -j8
	cp debug/libblusher.so.$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH) $(SHARED_LIB_TARGET_DIR)
	rm -f $(SHARED_LIB_TARGET_DIR)/libblusher.so.$(VERSION_MAJOR).$(VERSION_MINOR)
	ln -s libblusher.so.$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH) $(SHARED_LIB_TARGET_DIR)/libblusher.so.$(VERSION_MAJOR).$(VERSION_MINOR)
	rm -f $(SHARED_LIB_TARGET_DIR)/libblusher.so.$(VERSION_MAJOR)
	ln -s libblusher.so.$(VERSION_MAJOR).$(VERSION_MINOR) $(SHARED_LIB_TARGET_DIR)/libblusher.so.$(VERSION_MAJOR)
	rm -f $(SHARED_LIB_TARGET_DIR)/libblusher.so
	ln -s libblusher.so.$(VERSION_MAJOR) $(SHARED_LIB_TARGET_DIR)/libblusher.so

install:
	rm -rf /usr/lib/blusher
	cp -r lib/blusher /usr/lib/blusher
	rm -rf /usr/lib/libblusher.so*
	mv /usr/lib/blusher/qml/Blusher/libblusher.so* /usr/lib/

clean:
	rm -rf build
	rm -rf debug
	rm -f $(SHARED_LIB_TARGET_DIR)/libblusher.so*

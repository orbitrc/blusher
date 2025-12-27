default:
	swiftc -parse-as-library -I../../.build/debug/Modules -L../../.build/debug -lBlusher main.swift

run:
	LD_LIBRARY_PATH=../../.build/debug SWINGBY_BACKEND=opengl ./main

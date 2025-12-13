#!/usr/bin/env python3

print("= Blusher build configuration =\n")

print("BLUSHER_SWINGBY_INCLUDE_PATH: ", end="")
BLUSHER_SWINGBY_INCLUDE_PATH = input()

print("BLUSHER_SWINGBY_LIBRARY_PATH: ", end="")
BLUSHER_SWINGBY_LIBRARY_PATH = input()

print("BLUSHER_ENABLE_SWINGBY_RUNPATH: (ON/OFF) ", end="")
BLUSHER_ENABLE_SWINGBY_RUNPATH = input()

exports = open("exports", "w")
exports.write(f"export BLUSHER_SWINGBY_INCLUDE_PATH={BLUSHER_SWINGBY_INCLUDE_PATH}\n")
exports.write(f"export BLUSHER_SWINGBY_LIBRARY_PATH={BLUSHER_SWINGBY_LIBRARY_PATH}\n")
exports.write(f"export BLUSHER_ENABLE_SWINGBY_RUNPATH={BLUSHER_ENABLE_SWINGBY_RUNPATH}\n")

exports.close()

print("\nDone.")
print("Usage: $ source exports")

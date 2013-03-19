all:
	gcc -O3 -Wall -o osxplaypause.app/Contents/MacOS/osxplaypause -framework Cocoa -framework IOKit main.m

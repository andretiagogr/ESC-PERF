CC = g++
CFLAGS = -O3

default: sort

sort: main.c sort.c sort.h
	$(CC) $(CFLAGS) *.c -o sort

clean:
	rm -fv sort

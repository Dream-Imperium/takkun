VERSION = 1.0

# customize below to fit your system

# paths
PREFIX = /usr/local

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# includes and libs
INCS = -I. -I/usr/include -I${X11INC}
LIBS = -L/usr/lib -lc -lcrypt -L{X11LIB} -lX11 -lXext

# flags
CPPFLAGS = -DVERSION=\"${VERSION}\" -DHAVE_SHADOW_H -DCOLOR1=\"black\" -DCOLOR2=\"\#005577\"
CFLAGS = -std=c99 -pedantic -Wall -Os ${INCS} ${CPPFLAGS}
LDFLAGS = -s ${LIBS}

# on *BSD remove -DHAVE_SHADOW_H from CPPFLAGS and add -DHAVE_BSD_AUTH
# on OpenBSD and Darwin remove -lcrypt from LIBS

# compiler and linker
CC = cc

# install mode - on BSD systems MODE=2755 and GROUP=auth
# on others MODE=4755 and GROUP=root
#MODE=2755
#GROUP=auth
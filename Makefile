# takkun - screen locker for the extremely paranoid and mentally unstable
# This project is unencumbered into the public domain. See LICENSE for more information.

include config.mk

SRC = takkun.c
OBJ = ${SRC:.c=.o}

all: options takkun

options:
	@echo takkun build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.mk

takkun: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f takkun ${OBJ} takkun-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p takkun-${VERSION}
	@cp -R LICENSE Makefile README config.mk ${SRC} takkun-${VERSION}
	@tar -cf takkun-${VERSION}.tar takkun-${VERSION}
	@gzip takkun-${VERSION}.tar
	@rm -rf takkun-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f takkun ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/takkun
	@chmod u+s ${DESTDIR}${PREFIX}/bin/takkun

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/takkun

.PHONY: all options clean dist install uninstall
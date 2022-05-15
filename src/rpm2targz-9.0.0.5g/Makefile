CFLAGS += -Wall

VER ?= 9999
PV = 9.0.0.$(VER)g
P = rpm2targz-$(PV)

DESTDIR =
prefix = /usr
bindir = $(prefix)/bin
dodir = install -m 755 -d
dobin = install -m 755
dosym = ln -sf

all: rpmoffset rpm2tar
rpm2tar: rpm2targz
	$(dosym) $< $@

clean:
	rm -f *.o rpmoffset rpm2tar $(LINKS)

dist:
	git archive --prefix=$(P)/ master | xz > $(P).tar.xz

dist-live: clean
	rm -rf $(P)
	mkdir $(P)
	cp `find . -maxdepth 1 -type f '!' -name .gitignore` $(P)

LINKS = $(patsubst %,rpm2%,tar tarbz2 tbz2 tarlzma tgz tarxz txz)
links:
	set -e; for t in $(LINKS) ; do $(dosym) rpm2targz $$t ; done

install: rpmoffset
	$(dodir) $(DESTDIR)$(bindir)
	$(dobin) rpm2targz rpmoffset $(DESTDIR)$(bindir)
	set -e ; \
	for t in $(LINKS) ; do \
		$(dosym) rpm2targz $(DESTDIR)$(bindir)/$$t ; \
	done
	$(dosym) rpm2targz $(DESTDIR)$(bindir)/rpmunpack

check test:
	./test.sh

.PHONY: all clean install

COMMIT = $(shell (cd "$(SRCDIR)" && git rev-parse HEAD))

# Ensure "install" isn't the default
.PHONY: all
all:
	@echo "Usage: make install [DESTDIR=...]"
	@exit 1

.PHONY: install
install:
	install -D -m 0644 -t $(DESTDIR)/usr/lib/dracut/modules.d/51coreos-installer \
		dracut/systemd/coreos-installer-growfs.service \
		dracut/systemd/coreos-installer-luks-open.service \
		dracut/systemd/coreos-installer-noreboot.service \
		dracut/systemd/coreos-installer-poweroff.service \
		dracut/systemd/coreos-installer-reboot.service \
		dracut/systemd/coreos-installer.service \
		dracut/systemd/coreos-installer.target
	install -D -m 0755 -t $(DESTDIR)/usr/lib/dracut/modules.d/51coreos-installer \
		dracut/51coreos-installer/module-setup.sh \
		dracut/scripts/coreos-installer-growfs \
		dracut/scripts/coreos-installer-service \
		dracut/systemd/coreos-installer-generator

RPM_SPECFILE=rpmbuild/SPECS/coreos-installer-dracut-$(COMMIT).spec
RPM_TARBALL=rpmbuild/SOURCES/coreos-installer-dracut-$(COMMIT).tar.gz

$(RPM_SPECFILE):
	mkdir -p $(CURDIR)/rpmbuild/SPECS
	(echo "%global commit $(COMMIT)"; git show HEAD:test/coreos-installer-dracut.spec) > $(RPM_SPECFILE)

$(RPM_TARBALL):
	mkdir -p $(CURDIR)/rpmbuild/SOURCES
	git archive --prefix=coreos-installer-dracut-$(COMMIT)/ --format=tar.gz HEAD > $(RPM_TARBALL)

.PHONY: srpm
srpm: $(RPM_SPECFILE) $(RPM_TARBALL)
	rpmbuild -bs \
		--define "_topdir $(CURDIR)/rpmbuild" \
		$(RPM_SPECFILE)

.PHONY: rpm
rpm: $(RPM_SPECFILE) $(RPM_TARBALL)
	rpmbuild -bb \
		--define "_topdir $(CURDIR)/rpmbuild" \
		$(RPM_SPECFILE)
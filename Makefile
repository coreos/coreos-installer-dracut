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

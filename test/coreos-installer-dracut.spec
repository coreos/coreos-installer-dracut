%define dracutlibdir %{_prefix}/lib/dracut
%global         forgeurl https://github.com/coreos/coreos-installer-dracut
%global debug_package %{nil}

Version:        99

%forgemeta -v -i

Name:           coreos-installer-dracut

Release:        1%{?dist}
Summary:        Installer for Fedora CoreOS and RHEL CoreOS

# Upstream license specification: Apache-2.0
License:        ASL 2.0

URL:            %{forgeurl}

Source0:        %{forgesource}

%global _description %{expand:
coreos-installer installs Fedora CoreOS or RHEL CoreOS to bare-metal
machines (or, occasionally, to virtual machines).
}

%description %{_description}

%prep
%forgesetup

%build

%install
%make_install

%files
%{dracutlibdir}/modules.d/51coreos-installer

%changelog
# let's skip this for now
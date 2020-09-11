#
# spec file for package kiwi-boot-descriptions
#
# Copyright (c) 2019 SUSE LINUX GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via https://bugs.opensuse.org/
#
# translate version id to distribution name
# SLE12:
%if 0%{?suse_version} == 1315 && !0%{?is_opensuse}
%define distro suse-SLES12
%endif

# SLE15:
%if 0%{?suse_version} == 1500 && !0%{?is_opensuse}
%define distro suse-SLES15
%endif

Name:           kiwi-boot-descriptions
Version:        1.3.0
Release:        0
Url:            https://github.com/SUSE/kiwi-descriptions
Summary:        KIWI - Custom Boot Descriptions
License:        GPL-3.0-or-later
Group:          System/Management
Source:         %{name}.tar.gz
Source1:        kiwi-boot-packages
Source2:        %{name}-rpmlintrc
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
%if 0%{?fedora} || 0%{?suse_version}
BuildRequires:  fdupes
%endif
%if 0%{?fedora} || 0%{?rhel}
BuildRequires:  gettext
%endif
%if 0%{?suse_version}
BuildRequires:  gettext-runtime
%endif

%description
Custom KIWI boot descriptions. Before KIWI switched to dracut
as initrd system, the initrd was build from extra image descriptions.
The collection of those image descriptions is available for
convenience and compatibility reasons. Also creating meta sub packages
for the buildservice to allow inclusion of tools into the worker
which are needed to build a specific image type

%if 0%{?distro}
%package -n kiwi-boot-requires
Summary:        KIWI - buildservice package requirements for boot images
Group:          System/Management
Provides:       kiwi-boot:netboot
Provides:       kiwi-boot:oemboot
Requires:       kiwi-boot-descriptions
%if !0%{?is_opensuse} || 0%{?sle_version} < 150200
Requires:       %(echo `cat %{S:1}|grep %{_target_cpu}:%{distro}:|cut -f3- -d:`)
%endif

%description -n kiwi-boot-requires
Meta package for the buildservice to pull in all required packages in
order to have them in the buildservice created repositories to allow
kiwi to build the custom boot image.
%endif

%package -n kiwi-image-wsl-requires
Summary:        KIWI - buildservice host requirements for wsl images
Group:          System/Management
Provides:       kiwi-image:wsl
Requires:       fb-util-for-appx

%description -n kiwi-image-wsl-requires
Meta package for the buildservice to pull in all required packages
for the build host to build wsl/appx images

%package -n kiwi-image-docker-requires
Summary:        KIWI - buildservice host requirements for docker images
Group:          System/Management
Provides:       kiwi-image:docker
Requires:       jing
Requires:       skopeo
Requires:       umoci

%description -n kiwi-image-docker-requires
Meta package for the buildservice to pull in all required packages
for the build host to build docker images

%package -n kiwi-image-iso-requires
Summary:        KIWI - buildservice host requirements for iso images
Group:          System/Management
Provides:       kiwi-image:iso
Requires:       checkmedia
Requires:       dosfstools
Requires:       jing
%if 0%{?suse_version} >= 1500
Requires:       mkisofs
%else
Requires:       genisoimage
%endif
%ifarch %{ix86} x86_64
Requires:       syslinux
%endif
%description -n kiwi-image-iso-requires
Meta package for the buildservice to pull in all required packages
for the build host to build live iso images

%package -n kiwi-image-oem-requires
Summary:        KIWI - buildservice host requirements for oem images
Group:          System/Management
Provides:       kiwi-image:oem
Requires:       jing
Requires:       kiwi-filesystem-requires
%ifarch %{ix86} x86_64
Requires:       syslinux
%endif
%description -n kiwi-image-oem-requires
Meta package for the buildservice to pull in all required packages
for the build host to build oem disk images

%package -n kiwi-image-pxe-requires
Summary:        KIWI - buildservice host requirements for pxe images
Group:          System/Management
Provides:       kiwi-image:pxe
Requires:       jing
Requires:       kiwi-filesystem-requires

%description -n kiwi-image-pxe-requires
Meta package for the buildservice to pull in all required packages
for the build host to build pxe images

%package -n kiwi-image-vmx-requires
Summary:        KIWI - buildservice host requirements for vmx images
Group:          System/Management
Provides:       kiwi-image:vmx
Requires:       jing
Requires:       kiwi-filesystem-requires

%description -n kiwi-image-vmx-requires
Meta package for the buildservice to pull in all required packages
for the build host to build simple disk images

%package -n kiwi-image-tbz-requires
Summary:        KIWI - buildservice host requirements for root archive tarball
Group:          System/Management
Provides:       kiwi-image:tbz
Requires:       jing
Requires:       tar
Requires:       xz

%description -n kiwi-image-tbz-requires
Meta package for the buildservice to pull in all required packages
for the build host to build root archive tarball

%package -n kiwi-filesystem-requires
Summary:        KIWI - buildservice host requirements for filesystems
Group:          System/Management
Provides:       kiwi-filesystem:btrfs
Provides:       kiwi-filesystem:ext3
Provides:       kiwi-filesystem:ext4
Provides:       kiwi-filesystem:squashfs
Provides:       kiwi-filesystem:xfs
Requires:       e2fsprogs
Requires:       jing
Requires:       xfsprogs
%if 0%{?fedora} || 0%{?rhel}
Requires:       btrfs-progs
Requires:       squashfs-tools
%else
Requires:       btrfsprogs
Requires:       squashfs
%endif
%description -n kiwi-filesystem-requires
Meta package for the buildservice to pull in a collection of
filesystem packages for the build host to support the most common
used filesystems for images

%prep
%setup -q -n custom_boot

%build

%install
make buildroot=%{buildroot} install 

%if 0%{?fedora} || 0%{?suse_version}
%fdupes %{buildroot}/%{_datadir}/kiwi/custom_boot
%endif

%files -n kiwi-boot-descriptions
%defattr(-, root, root)
%dir %{_datadir}/kiwi
%{_datadir}/kiwi/custom_boot

%if 0%{?distro}
%files -n kiwi-boot-requires
%defattr(-, root, root)
%endif

%files -n kiwi-image-wsl-requires
%defattr(-, root, root)

%files -n kiwi-image-docker-requires
%defattr(-, root, root)

%files -n kiwi-image-iso-requires
%defattr(-, root, root)

%files -n kiwi-image-oem-requires
%defattr(-, root, root)

%files -n kiwi-image-pxe-requires
%defattr(-, root, root)

%files -n kiwi-image-vmx-requires
%defattr(-, root, root)

%files -n kiwi-image-tbz-requires
%defattr(-, root, root)

%files -n kiwi-filesystem-requires
%defattr(-, root, root)

%changelog

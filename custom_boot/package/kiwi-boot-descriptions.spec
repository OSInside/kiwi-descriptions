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

%changelog

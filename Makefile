#
#   Copyright (C) 2018-2020 CASM Organization <https://casm-lang.org>
#   All rights reserved.
#
#   Developed by: Philipp Paulweber
#                 <https://github.com/casm-lang/casm-lang.pkg.appimage>
#
#   This file is part of casm-lang.pkg.appimage.
#
#   casm-lang.pkg.appimage is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   casm-lang.pkg.appimage is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with casm-lang.pkg.appimage. If not, see <http://www.gnu.org/licenses/>.
#

PACKAGE=casm
VERSION=0.4.0
ARCHIVE=tar.gz

LOGO=https://github.com/casm-lang/casm-lang.logo/raw/master/obj/icon/256.png

OS=$(shell uname | tr '[:upper:]' '[:lower:]')
ARCH=$(shell uname -m)
SERVER=https://github.com/casm-lang/$(PACKAGE)/releases/download
FILE=$(PACKAGE)-$(OS)-$(ARCH).$(ARCHIVE)
BUNDLE=$(VERSION)/$(FILE)
URL=$(SERVER)/$(BUNDLE)

OBJ=obj
APP=$(PACKAGE).AppDir
EXE=$(PACKAGE)-$(ARCH).AppImage
BIN=$(PACKAGE)-$(OS)-$(ARCH).AppImage
SIG=$(BIN).sha2

default:
	mkdir -p $(OBJ)
	mkdir -p $(APP)
	mkdir -p $(APP)/usr

	wget $(URL)
	mv $(FILE) $(OBJ)
	(cd $(OBJ); tar xvf $(FILE))

	mv $(OBJ)/$(PACKAGE)-$(VERSION)/* $(APP)/usr/
	sed -i -e 's#/usr#././#g' $(APP)/usr/bin/casmi

	cp src/AppRun $(APP)/

	desktop-file-validate src/casm.desktop
	cp src/$(PACKAGE).desktop $(APP)/

	wget $(LOGO)
	mv 256.png $(APP)/$(PACKAGE).png
	ARCH=$(ARCH) appimagetool $(APP)
	mv $(EXE) $(BIN)
	sha256sum $(BIN) > $(SIG)

clean:
	rm -rf $(OBJ)
	rm -rf $(APP)
	rm -f $(BIN)
	rm -f $(SIG)

CXX = g++
CXX_FLAGS = -Wall -std=c++14 -lpthread -s
DESTDIR = ./bin/
SRC_SERVER = ./src/server.cpp
SRC_CLIENT = ./src/client.cpp
INSTALL_DIR = /usr/local/bin/

GREEN = \033[0;32m
YELLOW = \033[0;33m
RESET = \033[0m
RED = \033[0;31m

DEBVERSION = 1.0.1
ARCH = amd64
DEBPACKAGENAME = udpchat-$(DEBVERSION)-1_$(ARCH)

build:
	@echo -e "$(GREEN)[ $(YELLOW)25% $(GREEN)] $(RESET)CC SERVER"
	@$(CXX) -o $(DESTDIR)server $(SRC_SERVER) $(CXX_FLAGS)
	@echo -e "$(GREEN)[ $(YELLOW)50% $(GREEN)] $(RESET)CC CLIENT"
	@$(CXX) -o $(DESTDIR)client $(SRC_CLIENT) $(CXX_FLAGS)
	@echo -e "$(GREEN)[ $(YELLOW)75% $(GREEN)] $(RESET)STRIP SERVER"
	@upx $(DESTDIR)server >> /dev/null
	@echo -e "$(GREEN)[ $(YELLOW)100% $(GREEN)] $(RESET)STRIP CLIENT"
	@upx $(DESTDIR)client >> /dev/null
	@echo -e "$(GREEN)BUILD SUCCESS$(RESET)"

runserver:
	@$(DESTDIR)server 127.0.0.1 43243

runclient:
	@$(DESTDIR)client 127.0.0.1 43243

install:
	@mkdir -p $(INSTALL_DIR)
	@echo -e "$(GREEN)[ $(YELLOW)50% $(GREEN)] $(RESET)INSTALL SERVER"
	@cp -rf $(DESTDIR)server $(INSTALL_DIR)udpchatserver
	@echo -e "$(GREEN)[ $(YELLOW)100% $(GREEN)] $(RESET)INSTALL CLIENT"
	@cp -rf $(DESTDIR)client $(INSTALL_DIR)udpchatclient
	@echo -e "$(GREEN)INSTALL SUCCESS$(RESET)"

debpkg:
	@echo -e "$(GREEN)[ $(YELLOW)15% $(GREEN)] $(RESET)CREATE PACKAGE DIRECTORIES"
	@rm -rf $(DEBPACKAGENAME)
	@mkdir -p $(DEBPACKAGENAME)/usr/local/bin
	@echo -e "$(GREEN)[ $(YELLOW)45% $(GREEN)] $(RESET)COPY PACKAGE FILES"
	@cp -rf $(DESTDIR)server $(DEBPACKAGENAME)/usr/local/bin/udpchatserver
	@cp -rf $(DESTDIR)client $(DEBPACKAGENAME)/usr/local/bin/udpchatclient
	@echo -e "$(GREEN)[ $(YELLOW)75% $(GREEN)] $(RESET)CREATE PACKAGE METADATA"
	@mkdir $(DEBPACKAGENAME)/DEBIAN
	@touch $(DEBPACKAGENAME)/DEBIAN/control
	@echo -e "$(GREEN)[ $(YELLOW)100% $(GREEN)] $(RESET)CREATE PACKAGE"
	@echo -e "Package: udpchat\nVersion: 1.0.1\nArchitecture: $(ARCH)\nMaintainer: Tola Mironcenko <mironcenkotola@gmail.com>\nDescription: This is small chat in terminal" >> $(DEBPACKAGENAME)/DEBIAN/control
	@dpkg-deb --build --root-owner-group $(DEBPACKAGENAME)
	@echo -e "$(GREEN)BUILDING DEBIAN PACKAGE SUCCESS$(RESET)"

archlinuxpkg:
	@makepkg -f

all:
	@make build
	@make debpkg
	@make archlinuxpkg
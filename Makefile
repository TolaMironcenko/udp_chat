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
	@echo -e "$(GREEN)[ $(YELLOW)50% $(GREEN)] $(RESET)INSTALL SERVER"
	@cp -rf $(DESTDIR)server $(INSTALL_DIR)udpchatserver
	@echo -e "$(GREEN)[ $(YELLOW)100% $(GREEN)] $(RESET)INSTALL CLIENT"
	@cp -rf $(DESTDIR)client $(INSTALL_DIR)udpchatclient
	@echo -e "$(GREEN)INSTALL SUCCESS$(RESET)"
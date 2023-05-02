CXX = g++
CXX_FLAGS = -Wall -std=c++14 -lpthread -s
DESTDIR = ./bin/
SRC_SERVER = ./src/server.cpp
SRC_CLIENT = ./src/client.cpp
INSTALL_DIR = /usr/local/bin/

build:
	$(CXX) -o $(DESTDIR)server $(SRC_SERVER) $(CXX_FLAGS)
	$(CXX) -o $(DESTDIR)client $(SRC_CLIENT) $(CXX_FLAGS)
	upx $(DESTDIR)server
	upx $(DESTDIR)client

runserver:
	./server 127.0.0.1 8000

runclient:
	./client 127.0.0.1 8000

install:
	cp -rf $(DESTDIR)server $(INSTALL_DIR)udpchatserver
	cp -rf $(DESTDIR)client $(INSTALL_DIR)udpchatclient
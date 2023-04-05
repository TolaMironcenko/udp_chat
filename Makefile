build:
	g++ -o server server.cpp
	g++ -o client client.cpp -std=c++14 -lpthread

runserver:
	./server 127.0.0.1 8000

runclient:
	./client 127.0.0.1 8000
build:
	clang++ -o server server.cpp
	clang++ -o client client.cpp -std=c++11

runserver:
	./server 127.0.0.1 8000

runclient:
	./client 127.0.0.1 8000
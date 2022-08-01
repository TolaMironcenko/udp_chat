#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <typeinfo>
#include <ctime>

using namespace std;

//структура одного клиента на сервере
struct client_t {
    sockaddr_in addr;
    char username[1024]; //пример данных которые нужно менять при отправке пакета от клиента на наш сервер
};

const int num_of_clients = 64; // количество клиентов
client_t clients[num_of_clients];

bool HaveClient(sockaddr_in addr)
{
    for(int i = 0; i < num_of_clients; i++)
        if(clients[i].addr.sin_addr.s_addr == addr.sin_addr.s_addr && clients[i].addr.sin_port == addr.sin_port)
            return true;
    
    return false; 
}

int main(int argc, char** argv) {

	if (argc != 3) {
		printf("Usage: %s ip port\n", argv[0]);
		exit(0);
	}

	char* ip = argv[1];
	int port = atoi(argv[2]);

	int sockfd = -1;
	struct sockaddr_in server_addr;
	socklen_t addr_size;
	int n;

	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
	if (sockfd < 0) {
		perror("[-] socket error");
		exit(1);
	}

	memset(&server_addr, '\0', sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(port);
	server_addr.sin_addr.s_addr = inet_addr(ip);

	n = bind(sockfd, (struct sockaddr*)&server_addr, sizeof(server_addr));

	if (n < 0) {
		perror("[-] bind error");
		exit(1);
	}

	sockaddr_in client_addr;
	unsigned int clientlength = sizeof(client_addr);

	for (int i = 0; i < num_of_clients; i++) {
		cout << clients[i].addr.sin_port << clients[i].addr.sin_addr.s_addr << ";";
	}


	char buffer[1024];
	fd_set  rset;

	FD_ZERO(&rset);
	int maxfdp1 = sockfd + 1;
	int nready;

	while (1) {
		FD_SET(sockfd, &rset);
		if ((select(maxfdp1, &rset, NULL, NULL, NULL)) < 0) {
			if (errno == EINTR)
				continue;
			else
				perror("select error");
		}

		if (FD_ISSET(sockfd, &rset)) {
			bzero(buffer, 1024);
			clientlength = sizeof(client_addr);
			int bytesin = recvfrom(sockfd, buffer, 1024, 0, (sockaddr *) &client_addr, &clientlength);
			if (bytesin < 0) {
				cout << "error receving from client" << endl;
				continue;
			}
			if (!HaveClient(client_addr)) {
				for(int i = 0; i < num_of_clients; i++) {
					if (clients[i].addr.sin_port == 0 && clients[i].addr.sin_addr.s_addr == 0) {
						clients[i].addr = client_addr;
						strcpy(clients[i].username, buffer);
						break;
					}
				}
			}else {
				for (int i = 0; i < num_of_clients; i++) {
					if (clients[i].addr.sin_port != 0 && clients[i].addr.sin_addr.s_addr != 0) {
						if (!(clients[i].addr.sin_port == client_addr.sin_port && clients[i].addr.sin_addr.s_addr == client_addr.sin_addr.s_addr)) {
							char res[1024];
							char time[128];
							std::time_t t = std::time(nullptr);
    						std::tm* now = std::localtime(&t);
    						strftime(time, sizeof(time), "%X", now);

    						for (int i = 0; i < num_of_clients; i++) {
								if (clients[i].addr.sin_addr.s_addr == client_addr.sin_addr.s_addr && clients[i].addr.sin_port == client_addr.sin_port) {
									strcpy(res, clients[i].username);
								}
							}
							strcat(res, " [");
							strcat(res, time);
							strcat(res, "] : ");
							strcat(res, buffer);
							sendto(sockfd, res, 1024, 0, (sockaddr *) &clients[i].addr, sizeof(clients[i].addr));
						}
					}
				}
			}
		}
	}

    return 0;
}
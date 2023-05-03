#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <thread>
#include "colors.h"

void send_message(int sockfd, struct sockaddr_in addr) {
	while (1) {
		char buffer[1024];
		bzero(buffer, 1024);
		std::cin.getline(buffer, 1024);
		if(!strcmp(buffer, "quit")) {
			std::cout << GREEN << "you are exited.\n" << RESET; 
			exit(0);
		}
		sendto(sockfd, buffer, 1024, 0, (struct sockaddr*)&addr, sizeof(addr));
	}
}

int main(int argc, char** argv) {

	if (argc != 3) {
		printf("Usage: %s ip port\n", argv[0]);
		exit(0);
	}
	if (strlen(*argv) < 3) {
		printf("Usage: %s ip port\n", argv[0]);
		exit(0);
	}

	char* ip = argv[1];
	int port = atoi(argv[2]);

	int sockfd;
	struct sockaddr_in addr;
	char buffer[1024];
	socklen_t addr_size;

	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
	if (sockfd < 0) {
		perror("[-] socket error");
		exit(1);
	}

	memset(&addr, '\0', sizeof(addr));
	addr.sin_family = AF_INET;
	addr.sin_port = htons(port);
	addr.sin_addr.s_addr = inet_addr(ip);

	char username[50];
	std::cout << "Enter your username:\n\t" << GREEN;
	bzero(username, 50);
	std::cin.getline(username, 50);
	sendto(sockfd, username, 50, 0, (struct sockaddr*)&addr, sizeof(addr));
	std::cout << RESET << "Your username: " << GREEN << username << RESET << std::endl;

	std::thread t1(send_message, sockfd, addr);

	while (1) {
		bzero(buffer, 1024);
		addr_size = sizeof(addr);
		recvfrom(sockfd, buffer, 1024, 0, (struct sockaddr*)&addr, &addr_size);
		std::cout << buffer << std::endl;
	}
    

	t1.join();
    return 0;

}
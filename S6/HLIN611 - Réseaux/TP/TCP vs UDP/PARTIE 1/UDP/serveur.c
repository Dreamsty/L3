#include <stdio.h>
#include <sys/types.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>

/* Rôle du serveur (attention, se serveur ne traite qu'un client !) :
 -  accepter la demande de connexion d'un client ;

 - en boucle (infinie) : 1) recevoir un message de type "long int" ;
   2) comparer sa valeur avec la précédente reçue ; 3) si la valeur
   reçue est inférieure à la précédente, afficher une trace notifiant
   ce cas; 4) dans tous les cas, afficher le nombre total d'octets
   reçus depuis le début et le nombre d'appels à la fonction recv(...)

 - termine apres départ du client.

*/


/* Réutiliser les fonctions de l'exercice 3 du TP précédent */
/* les deux derniers parametres sont les compteurs, auxquels doit s'ajouter le nombre d'octets
   lus depuis le buffer de réception et le nombre d'appels reussis à recv(..)
   (ils sont initialisés par l'appelant.*/
/* Si vous avez utilisé des variables globales, pas de souci. */
int recvTCP(int socket, char *buffer, size_t length, unsigned int *nbBytesReceved, unsigned int * nbCallRecv){

  int received = 1;
  int nbBytes = length;

  while(received == 1){
    
    received = recv(socket, buffer, length, 0);

    if (received <= 0){
      return received;
    }

    buffer += received;
    nbBytes -= received;

    (*nbBytesReceved) += received;
    (*nbCallRecv)++;

    printf("Serveur : j'ai reçu au total %d octets avec %d appels à recv \n", *nbBytesReceved, *nbCallRecv);
  }
  
  return 1;
}

int main(int argc, char *argv[]){
   
  if (argc<2){
    printf("utilisation: %s numero_port\n", argv[0]);
    exit(1);
  }
  
  /*  Création de la socket d'écoute, nomage et mise en écoute.*/
 
  int ds = socket(PF_INET, SOCK_DGRAM, 0);


  // Penser à tester votre code progressivement.
  if (ds == -1){
    perror("Serveur : probleme creation socket");
    exit(1);
  }

  printf("Serveur : creation de la socket : ok\n");


  // Rappel un seul client est à traiter.
  printf("Serveur : j'attends la demande du client (accept) \n"); 
  

  struct sockaddr_in server;
  server.sin_family = AF_INET;
  server.sin_addr.s_addr = INADDR_ANY;
  server.sin_port = htons(atoi(argv[1]));

  if(bind(ds, (struct sockaddr*) &server, sizeof(server)) < 0){
    perror("Serveur : erreur bind");
    close(ds);
    exit(1);
  }

  printf("Serveur : nommage : ok\n");

  /* Réception de messages, chaque message est un long int */
 
  long int messagesRecus[2];   // je defini ce tableau pour garder le
             // message précédent (voir plus bas)

  unsigned int nbTotalOctetsRecus = 0;
  unsigned int nbAppelRecvfrom = 0;

  struct sockaddr_in addrC; // pour obtenir l'adresse du client accepté.
  socklen_t lgAddrC = sizeof (struct sockaddr_in);


  // recevoir un premier message puis mettre en place la boucle de
  // réception de la suite.
  printf("Serveur: j'attends de recevoir un premier message\n");
  
  int rcv = recvfrom(ds, (char *) messagesRecus, sizeof(long int), 0, (struct sockaddr *) &addrC, &lgAddrC);

  printf("Serveur : le client %s:%d m'a envoyé un message\n", inet_ntoa(addrC.sin_addr), ntohs(addrC.sin_port));


  /* Traiter TOUTES les valeurs de retour (voir le cours ou la documentation). */
  if (rcv < 0){ 
    perror ("Serveur : probleme reception :");
    close(ds);
    exit (1);
  }

  nbAppelRecvfrom++;
  nbTotalOctetsRecus += rcv;
  printf("Serveur : j'ai reçu au total %d octets avec %d appels à recv \n", nbTotalOctetsRecus, nbAppelRecvfrom);

  
  /* ce code commenté vous sera utile pour quelques tests.
  printf("Serveur : saisir un caractère avant de poursuivre \n");
  fgetc(stdin);
  */

  while(1){ // le serveur n'a pas connaissance du nombre de messages
        // qu'il recevra, donc, il boucle et la gestion des
        // valeurs de retours de fonctions permettra de sortir
        // de la boucle pour arrêter le serveur.
    
    int rcv = recvfrom(ds, (char *) (messagesRecus+1), sizeof(long int), 0, (struct sockaddr *) &addrC, &lgAddrC);

    /* Traiter TOUTES les valeurs de retour (voir le cours ou la documentation). */
    if (rcv < 0){ 
      perror ( "Serveur : probleme reception :");
      close(ds);
      exit (1);
    }
    
    nbAppelRecvfrom++;
    nbTotalOctetsRecus += rcv;

    printf("Serveur: le client %s:%d m'a envoyé un message  \n", inet_ntoa(addrC.sin_addr), ntohs(addrC.sin_port));

    if(messagesRecus[1] < messagesRecus[0]){ // si la valeur reçue est inférieure à la précédente, alors désordre.
      printf("Serveur : reception dans le désordre : %ld reçu après %ld\n", messagesRecus[1], messagesRecus[0]);
    }

    /* garder la valeur précédente pour la prochaine comparaison*/
    messagesRecus[0] = messagesRecus[1];
  
    printf("Serveur : j'ai reçu au total %d octets avec %d appels à recv \n", nbTotalOctetsRecus, nbAppelRecvfrom);
  }
  
  // terminer proprement votre programme
  close (ds);
  printf("Serveur : je termine\n");
}
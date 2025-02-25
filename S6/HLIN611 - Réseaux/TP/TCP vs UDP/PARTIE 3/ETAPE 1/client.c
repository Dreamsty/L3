#include <stdio.h> 
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <string.h>

/* Rôle du client : 
- envoyer une demande de connexion à un serveur,

- envoyer au serveur la suite d'entiers (de type long int) de 1 à N,
   où chaque entier est un message à part entière (un appel à sendTCP
   par entier). N est passé en paramètre du programme client,

- afficher le nombre total d'appels de la fonction send et le nombre total d'octets effcetivement envoyés,

- terminer poprement
*/



/* Réutiliser les fonctions de l'exercice 3 du TP précédent */
/* les deux derniers parametres sont les compteurs, auxquels doit s'ajouter le nombre d'octets
   déposés dans le buffer d'envoi et le nombre d'appels reussis à send(..)
   (ils sont initialisés par l'appelant.*/
/* Si vous avez utilisé des variables globales, pas de souci. */
int sendTCP(int socket, const char * buffer, size_t length, unsigned int *nbBytesSent, unsigned int * nbCallSend){

  int sent = 1;
  size_t nbBytes = length;

  while(nbBytes != 0){
    
    sent = send(socket, buffer, nbBytes, 0);

    if (sent <= 0){
      return sent;
    }

    buffer += sent;
    nbBytes -= sent;

    (*nbBytesSent)+=sent;
    (*nbCallSend)++;
	}

  return 1;
}


int main(int argc, char *argv[]) {

  /* je passe en paramètre l'adresse de la socket d'écoute du serveur
     (IP et numéro de port) et le nombre N d'entiers à envoyerr. Je teste donc le passage de parametres */

  if (argc != 4){
    printf("utilisation : %s ip_serveur port_serveur N_nombre_entiers_e_envoyer\n", argv[0]);
    exit(0);
  }

  /* créer une socket, demader une connexion au serveur */   
	int ds = socket(PF_INET, SOCK_STREAM, 0);

	if (ds == -1){
		printf("Client : pb creation socket\n");
		exit(1);
	}

  // Je peux tester l'exécution de cette étape avant de passer à la suite.
	printf("Client : creation de la socket : ok\n");

  struct sockaddr_in adrServ;
	adrServ.sin_addr.s_addr = inet_addr(argv[1]) ;
	adrServ.sin_family = AF_INET;
	adrServ.sin_port = htons(atoi(argv[2]));

  socklen_t lgAdr = sizeof(struct sockaddr_in);

	/* Etape 3 : envoyer une demande de connexion au serveur.*/
	int conn = connect(ds, (struct sockaddr *) &adrServ, lgAdr);

	// je traite les valeurs de retour
	if (conn < 0){
		perror ("Client : pb au connect :");
		close (ds);
    exit(1);
	}

	printf("Client : demande de connexion reussie \n");

  long int message;
  unsigned int nbTotalOctetsEnvoyes = 0;
  unsigned int nbAppelSend = 0;

  for(int i = 1; i <= atoi(argv[3]); i++){
    message = i; // pour passer d'un int à long int (de 4 à 8 octets). Vous pouvez faire autrement.
    
    int sent = sendTCP(ds, (char*)&message, sizeof(long int), &nbTotalOctetsEnvoyes, &nbAppelSend);

    /* Traiter TOUTES les valeurs de retour (voir le cours ou la documentation). */
    if (sent < 0) {
      perror("Client : erreur lors de l'envoi :");
      close(ds);
      exit(1);
    }
    else if (sent == 0) {
      printf("Client: serveur déconnecté \n");
      break;
    }

    printf("Client : j'ai envoyé au total %d octets avec %d appels à send \n",nbTotalOctetsEnvoyes,  nbAppelSend) ;

  }

  /*Terminer proprement. */
  printf("Client : je termine\n");
  close(ds);

}

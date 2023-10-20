# Notre jeu de logique

Notre jeu est un RPG Textuel, demandant une certaine réflexion sur les actions à faire.
Vous récupérerez des objets afin d'avancer dans l'histoire.
De nombreuses interactions seront possibles tout au long de votre aventure.
Les commandes les plus utiles seront :

  - Observer \[objet\] : Vous affiche un petit texte décrivant l'objet/personnage.
  - Interagir \[objet\] : Peut enclencher une action importante pour l'histoire avec certains objets/personnages.
  - Aller {emplacement} : Pour vous déplacer au prochain emplacement.

N'hésitez pas à faire "instructions." pour voir toutes les commandes possibles.
Cette liste d'instructions s'actualisera tout au long de la partie ! N'hésitez pas à la consulter lorsqu'on vous le conseille.
 
## Partie technique

 Des raccourcis seront possibles pour chaque commande importante.
 Les voici :

    o(X) :- observer(X).
    int(X) :- interagir(X).
    inv :- inventaire.
    c(X) :- carnet(X).
    go(X) :- aller(X).
    cut(X) :- couper(X).
    cr(X) :- creuser(X).
    b :- retour.
    r :- regarder.

### Gestion des actions sur les objets

    Certains objets peuvent satisfaire un prédicat "coupage/1". Par exemple, l'arbre, accessible depuis le sentier de la forêt, est déclaré avec :

      position(arbre, sentier).
      coupage(arbre).

    L'action "couper/1", ajoute l'objet coupé dans une liste contenant tous les objets coupés.
    Il sera donc possible d'afficher un texte différent en fonction de si un objet est coupé ou non, et de par exemple débloquer un passage si des ronces sont coupées.

    Il est ensuite possible de vérifier si quelque chose est dans une liste avec ceci :
      %Récupération de la liste des objets coupés
      cutList(Cut),
      %Vérification si le "tronc", à l'emplacement "ruisseau" dans le monde 0 est dans la liste Cut.
      list_check_place(tronc, ruisseau, 0, Cut),

    Exemple :
      jouer.
      %On essaye d'accéder au ruisseau. Cette action n'est pas possible puisqu'il est bloqué par des ronces
      go ruisseau.
      %Nous ajoutons les ronces dans la liste des objets coupés.
      couper ronces.
      %Nous pouvons désormais passer vers le ruisseau.
      go ruisseau.
    
    La même mécanique existe pour creuser.

### Gestion d'un inventaire

    Lorsque vous récupérez un objet, celui-ci va directement dans votre inventaire. Ceci nécéssite les prédicats suivants :

      %Récupération de la liste contenant l'inventaire
      inventory(InventoryList),
      %Ajout de "1" "Couteau" dans la liste InventoryList, liste finale dans NewList.
      list_add(["Couteau", 1], InventoryList, NewList),
      %Suppression de l'ancien inventaire.
      retract(inventory(_)),
      %Remplacement par le nouvel inventaire.
      assert(inventory(NewList)).	

    La difficulté d'ajout dans l'inventaire réside dans le fait d'avoir plusieurs éléments. 
    Par exemple, si nous récupérons une buche, puis une seconde buche plus tard, il nous faut 2x Buche, et non pas 1x Buche / 1x Buche

      % Ajouter dans l'inventaire si l'item existe déjà
      list_add(Name, OldList, NewList):-
      %Récupération du nom de l'item
      nth0(0, Name, Element), 
      %Check s'il existe dans l'inventaire
      list_check_inventory(Element, OldList), 
      %Trouve son index
      indexOf(OldList, [Element, _], Index), 
      %Récupère le nombre qu'on ajoute à l'item
      nth0(1, Name, Ajout), 
      %Récupère l'ancien item dans la liste
      nth0(Index, OldList, AncienElem), 
      %Récupère le nombre d'items qu'il y a de base
      nth0(1, AncienElem, Base), 
      %Ajoute les 2
      NewNumber is Base + Ajout, 
      %Remplace l'ancien nombre par le nouveau
      change_list(Index, [Element, NewNumber], OldList, NewList). 

      % Ajouter dans une liste si ça existe pas déjà
      list_add(Name, OldList, NewList):-
      NewList = [Name|OldList].
    
### Gestion d'un carnet

    Dans notre jeu, vous pouvez analyser votre carnet après l'avoir récupéré dans la chambre.
    Ce carnet vous permettra d'afficher vos expériences dans les différentes salles.

    Il est possible d'accéder à la n-ième page du carnet avec la commande "carnet {n}".

    Ce carnet possède 4 pages, et peut avoir un texte différent sur chaque page.
    Pour cela, une liste d'actions est créée, et sera éditée à chaque fois qu'un évènement positif ou négatif est rencontré dans votre aventure.

    Il sera donc possible de vérifier si l'action 1 (Page 1), a été positive ou négative.
      %Récupération de la liste d'actions
      actions(Actions),
      %Regarde si l'index 0 est négatif ou pas (La valeur -1 serait fixée dans l'index 0 dans ce cas là.)
      check_if_negatif(Actions, 0)

    Une option supplémentaire pour aider votre déplacement dans le carnet existe, vous pouvez utiliser les prédicats

      "suiv."
      "prev."

    pour changer de page dans le carnet.

    Ceci est réalisé en sauvegardant la dernière page affichée, et incrémentant/décrémentant le numéro de la page.
      %Récupération de la dernière page
      dernierePage(Last),
      %Incrémente de 1 le numéro de la page
      increase(Last, New),
      %Vérifie s'il est à la dernière page
      \+ equal(New, 5),
      %Change le numéro de la page
      retract(dernierePage(Last)),
      assert(dernierePage(New)),
      %Lit la page
      lire(New),
      !.

### Fins alternatives

    Plusieurs fins sont possibles dans notre jeu.
    Les actions que vous faites influent sur votre avancement, activant 3 fins différentes.

    - La fin positive
    - La fin négative

    Les différentes fins sont décidées en fonction de la somme des "valeurs d'action".
    Votre liste d'actions, représentée telle quelle : [1,-1,1,1], peut avoir une somme positive ou négative.
    A la toute fin du jeu, une fin vous sera affichée en vérifiant grace à ce code :
      actions(Actions),
      somme(Actions, Res),
      check_if_positif(Res). / check_if_negatif(Res).
%%% INFO-501, TP3
%%% AUBERT Mathys - DUBOIS Joris
%%%
%%% Lancez la "requete"
%%% jouer.
%%% pour commencer une partie !
%

% il faut declarer les predicats "dynamiques" qui vont etre modifies par le programme.
:- dynamic position_courante/1.

% on remet a jours les positions des objets et du joueur
:- retractall(position(_, _)), retractall(position_courante(_)).

% position du joueur. Ce predicat sera modifie au fur et a mesure de la partie (avec `retract` et `assert`)
position_courante(chambre).

:- dynamic inventory/1.
inventory([]).

:- dynamic interactedList/1.
interactedList([]).

:- dynamic cutList/1.
cutList([]).

:- dynamic creusageList/1.
creusageList([]).

:- dynamic visited/1.
visited([]).

:- dynamic dernierePage/1.
dernierePage(_).

:- dynamic actions/1.
actions([0,0,0]).

:- dynamic cauchemar/1.
cauchemar(0).

% passages entre les differents endroits du jeu
passage(chambre, lit, lit, 0).
passage(chambre, etagere, etagere, 0). 
passage(chambre, bureau, bureau, 0).
passage(chambre, porte, hub_reve, 0).

passage(hub_reve, chansons, chansons, 0).
passage(chansons, foret, foret, 0).
passage(foret, sentier, sentier, 0).
passage(foret, maison, maison, 0).
passage(foret, ruisseau, ruisseau, 0).

passage(hub_reve, galeries, galeries, 0).
passage(galeries, couloir, couloir, 0).
passage(couloir, passage, passage, 0).
passage(couloir, escalier, escalier, 0).

passage(hub_cauchemar, porte, campement, 1).
passage(campement, foret, foret, 1).
passage(foret, maison, maison, 1).
passage(maison, ruisseau, ruisseau, 1).
passage(ruisseau, campement, campement, 1).

% RETOURS
retour(lit, chambre, 0). 
retour(etagere, chambre, 0). 
retour(bureau, chambre, 0).

retour(foret, chansons, 0).
retour(sentier, foret, 0).
retour(maison, foret, 0).
retour(ruisseau, foret, 0).

retour(couloir, galeries, 0).
retour(passage, couloir, 0).
retour(escalier, couloir, 0).

% position des objets
position(chat, lit, 0).
position(poster, lit, 0).
position(peluche, lit, 0).
position(origami, etagere, 0).
position(maths, etagere, 0).
position(logique, etagere, 0). 
position(photo, bureau, 0). 
position(figurine, bureau, 0). 
position(carnet, bureau, 0).

position(mathieu, chansons, 0).
position(maxime, chansons, 0).
position(feu, chansons, 0).
position(lune, chansons, 0).
position(ronces, foret, 0).
position(lianes, sentier, 0).
position(fruit, sentier, 0).
position(arbres, sentier, 0).
position(feuilles, sentier, 0).
position(hache, maison, 0).
position(fleurs, maison, 0).
position(branches, maison, 0).
position(eau, ruisseau, 0).
position(tronc, ruisseau, 0).
position(buche, ruisseau, 0).
position(animal, ruisseau, 0).

position(pelle, galeries, 0).
position(gerald, galeries, 0).
position(minerais, galeries, 0).
position(friable, couloir, 0).
position(toiles, couloir, 0).
position(joyaux, passage, 0).
position(pioche, passage, 0).
position(dynamite, escalier, 0).
position(trou, escalier, 0).
position(statuette, escalier, 0).

position(traces, campement, 1).
position(feu, campement, 1).
position(lune, campement, 1).
position(loups, campement, 1).
position(pluie, campement, 1).
position(ronces, foret, 1).
position(hache, maison, 1).
position(baton, maison, 1).
position(broussailles, maison, 1).
position(tronc, ruisseau, 1).
position(courant, ruisseau, 1).

position(misty, fin0, 2).
position(animal, fin1, 2).
position(gerald, fin2, 2).
position(loup, fin3, 2).
position(miroir, fin, 2).

% objets pouvants etre coupes
coupage(ronces, 0).
coupage(arbres, 0).
coupage(fruit, 0).
coupage(branches, 0).
coupage(tronc, 0).
coupage(animal, 0).
coupage(ronces, 1).
coupage(broussailles, 1).

% objets pouvants etre creuses
creusage(friable, 0).
creusage(joyaux, 0).
creusage(trou, 0).


increase(X, X1) :-
        X1 is X+1.

decrease(X, X1) :-
        X1 is X-1.

equal(List, Index, Y) :-
        nth0(Index, List, Element),
        Element == Y.

equal(X,Y) :-
        X == Y.

check_if_positif(List, Index) :-
        nth0(Index, List, Element),
        Element > 0.

check_if_positif(Num) :-
        Num > 0.

check_if_negatif(List, Index) :-
        nth0(Index, List, Element),
        Element < 0.

check_if_negatif(Num) :-
        Num < 0.

change_list(Index, NewVal, List, NewList) :-
        nth0(Index, List, _, TempList),
        nth0(Index, NewList, NewVal, TempList).

% Ajouter dans l'inventaire si l'item existe deja
list_add(Name, OldList, NewList):-
        nth0(0, Name, Element), %Recuperation du nom de l'item
        list_check_inventory(Element, OldList), %Check s'il existe dans l'inventaire
        indexOf(OldList, [Element, _], Index), %Trouve son index
        nth0(1, Name, Ajout), %Recupere le nombre qu'on ajoute a l'item
        nth0(Index, OldList, AncienElem), %Recupere l'ancien item dans la liste
        nth0(1, AncienElem, Base), %Recupere le nombre d'items qu'il y a de base
        NewNumber is Base + Ajout, %Ajoute les 2
        change_list(Index, [Element, NewNumber], OldList, NewList). %Remplace l'ancien nombre par le nouveau

% Ajouter dans une liste si ca existe pas deja
list_add(Name, OldList, NewList):-
        NewList = [Name|OldList].

indexOf([Element|_], Element, 0). % We found the element
indexOf([_|Tail], Element, Index):-
        indexOf(Tail, Element, Index1), % Check in the tail of the list
        Index is Index1 + 1.  % and increment the resulting index

% Rule to check if a place exists in a list.
list_check_place(Name, Place, Cauchemar, [[Name, Place, Cauchemar]|_]).
list_check_place(Name, Place, Cauchemar, [_|T]):- list_check_place(Name, Place, Cauchemar, T).

% Rule to check if a ceartin number of an item exists in a list.
list_check_inventory(Name, Number, [[Name, Number]|_]).
list_check_inventory(Name, Number, [_|T]):- list_check_inventory(Name, Number, T).

% Rule to check if an item exists in a list.
list_check_inventory(Name, [[Name, _]|_]).
list_check_inventory(Name, [_|T]):- list_check_inventory(Name, T).

remove_list(_, [], []).
remove_list(R, [R|T], T2) :- remove_list(R, T, T2).
remove_list(R, [H|T], [H|T2]) :- H \= R, remove_list(R, T, T2).

% observer quelque chose
observer(X) :-
        position_courante(P),
        cauchemar(Cauchemar),
        position(X, P, Cauchemar),
        description(X, Cauchemar),
        !.

observer(X) :-
        write("Il n'y a pas de "),
        write(X),
        write(" ici. Vous avez besoin de lunettes ?"), nl,
        fail.


% interagir avec quelque chose
% interagir avec quelque chose
interagir(X) :-
        cauchemar(Cauchemar),
        position_courante(Ici),
        position(X, Ici, Cauchemar),
        interagir1(X, Cauchemar), 
        !.

interagir(X) :-
        write("Il n'y a pas de "),
        write(X),
        write(" ici. Vous avez besoin de lunettes ?"), nl,
        fail.

interagir1(buche, 0) :-
        cutList(Cut),
        \+ list_check_place(tronc, ruisseau, 0, Cut),
        write("Il faut trouver un moyen de franchir le ruisseau pour faire cela."), nl.

interagir1(X, Cauchemar) :-
        position_courante(P),
        position(X, P, Cauchemar),
        interaction(X, Cauchemar), nl,
        interactedList(Interacted),
        list_add([X, P, Cauchemar], Interacted, NewList),
        retract(interactedList(_)),
        assert(interactedList(NewList)).    


% couper quelque chose
couper(X) :-
        cauchemar(Cauchemar),
        position_courante(Ici),
        position(X, Ici, Cauchemar),
        coupage(X, Cauchemar),
        couper1(X, Cauchemar), 
        !.

couper(X) :-
        cauchemar(Cauchemar),
        \+ coupage(X, Cauchemar),
        position_courante(Ici),
        position(X, Ici, Cauchemar),
        write("Vous ne pouvez pas couper "),
        write(X),
        write("."), nl,
        fail.

couper(X) :-
        cauchemar(Cauchemar),
        position_courante(Ici),
        \+ position(X, Ici, Cauchemar),
        write("Il n'y a pas de "),
        write(X),
        write(" ici. Qu'essayez-vous donc de couper ?"), nl,
        fail.

couper1(arbres, 0) :-
        cutList(Cut),
        list_check_place(arbres, sentier, 0, Cut),
        write("Si vous coupez tout les arbres de ce sentier, vous denaturerez ce dernier..."), nl.

couper1(arbres, 0) :-
        inventory(InventoryList),
        \+ list_check_inventory("Hache", InventoryList),
        write("Malgre vos efforts, vous vous rendez a l'evidence : Votre faible couteau ne vous permettra pas de couper cet enorme tronc d'arbre."), nl.

couper1(branches, 0) :-
        cutList(Cut),
        list_check_place(branches, maison, 0, Cut),
        write("Vous avez deja coupe la seule branche pouvant faire office de buche."), nl.

couper1(branches, 0) :-
        inventory(InventoryList),
        \+ list_check_inventory("Hache", InventoryList),
        write("Votre couteau ne semble pas affecter ne serait-ce que l'ecorce de la branche, il vous faudrait quelque chose de plus tranchant."), nl.

couper1(tronc, 0) :-
        cutList(Cut),
        \+ list_check_place(tronc, ruisseau, 0, Cut),
        inventory(InventoryList),
        \+ list_check_inventory("Hache", InventoryList),
        write("Vous essayez de couper le tronc avec votre couteau, mais, il s'avere inefficace..."), nl.

couper1(animal, 0) :-
        cutList(Cut),
        \+ list_check_place(tronc, ruisseau, 0, Cut),
        write("Il faut trouver un moyen de franchir le ruisseau pour faire cela."), nl.

couper1(X, Cauchemar) :-
        position_courante(P),
        cauchemar(Cauchemar),
        position(X, P, Cauchemar),
        coupage(X, Cauchemar),
        couperTexte(X, Cauchemar), nl,
        cutList(Cut),
        list_add([X, P, Cauchemar], Cut, NewList),
        retract(cutList(_)),
        assert(cutList(NewList)).

% creuser quelque chose
creuser(X) :-
        cauchemar(Cauchemar),
        position_courante(Ici),
        position(X, Ici, Cauchemar),
        creuser1(X, Cauchemar), 
        !.

creuser(X) :-
        cauchemar(Cauchemar),
        \+ creusage(X, Cauchemar),
        position_courante(Ici),
        position(X, Ici, Cauchemar),
        write("Vous ne pouvez pas couper "),
        write(X),
        write("."), nl,
        fail.

creuser(X) :-
        cauchemar(Cauchemar),
        position_courante(Ici),
        \+ position(X, Ici, Cauchemar),
        write("Il n'y a pas de "),
        write(X),
        write(" ici. Qu'essayez-vous donc de creuser ?"), nl,
        fail.

creuser1(trou, 0) :-
        interactedList(Interacted),
        \+ list_check_place(dynamite, escalier, 0, Interacted),
        write("Un trou ? Quel trou ? Je ne vois qu'une dynamite prete a exploser..."), nl.

creuser1(trou, 0) :-
        actions(Actions),
        equal(Actions, 1, 0),
        inventory(InventoryList),
        \+ list_check_inventory("Pioche", InventoryList),
        write("Vous tentez de creuser avec votre pelle... Cela ne semble pas efficace, le mur est trop solide !"), nl.

creuser1(X, Cauchemar) :-
        position_courante(P),
        cauchemar(Cauchemar),
        position(X, P, Cauchemar),
        creusage(X, Cauchemar),
        creuserTexte(X, Cauchemar), nl,
        creusageList(Creusage),
        list_add([X, P, Cauchemar], Creusage, NewList),
        retract(creusageList(_)),
        assert(creusageList(NewList)).


regarder :-
        position_courante(Ici),
        cauchemar(Cauchemar),
        description(Ici, Cauchemar), 
        !.


% analyser votre inventaire.
print_inventory([H|[]]):- 
        write('    '), 
        nth0(0, H, Nom),
        nth0(1, H, Number),
        write(Number),
        write("x "),
        write(Nom), nl, 
        !.
print_inventory([H|T]):-
	write('    '), 
        nth0(0, H, Nom),
        nth0(1, H, Number),
        write(Number),
        write("x "),
        write(Nom), nl, 
	print_inventory(T).

inventaire:-
	inventory(InventoryList),
	nl, write("Vous possedez : "), nl,
	print_inventory(InventoryList), nl.


% quelques raccourcis
o(X) :- observer(X).
int(X) :- interagir(X).
inv :- inventaire.
c(X) :- carnet(X).
go(X) :- aller(X).
cut(X) :- couper(X).
cr(X) :- creuser(X).
b :- retour.
r :- regarder.

:- op(1000, fx, o).
:- op(1000, fx, int).
:- op(1000, fx, inv).
:- op(1000, fx, c).
:- op(1000, fx, go).
:- op(1000, fx, cut).
:- op(1000, fx, cr).

% on declare des operateurs, pour autoriser `prendre torche` au lieu de `prendre(torche)`
:- op(1000, fx, observer).
:- op(1000, fx, interagir).
:- op(1000, fx, aller).
:- op(1000, fx, carnet).
:- op(1000, fx, couper).
:- op(1000, fx, creuser).

aller(Direction) :-
        cauchemar(Cauchemar),
        position_courante(Ici),
        passage(Ici, Direction, La, Cauchemar),
        deplacer(Direction, La, Cauchemar), 
        !.

aller(_) :-
        write("Ou essayez-vous d'aller ? Cet endroit n'existe pas."), nl,
        fail.

% deplacements
deplacer(porte, hub_reve, 0) :-
        inventory(InventoryList),
        \+ list_check_inventory("Carnet & Stylo", InventoryList),
        %%% CR_F_23
        write("Vous ne pouvez pas sortir sans prendre votre carnet !"), nl, nl.

deplacer(porte, hub_reve, 0) :-
        interactedList(Interacted),
        \+ list_check_place(chat, lit, 0, Interacted),
        %%% CR_F_17
        write("Vous mettez la main sur la poignee."), nl,
        write("Votre chat miaule et demande une caresse."), nl,
        write("Mieux vaut lui dire au revoir avant de partir."), nl, nl.

deplacer(chansons, chansons, 0) :-
        visited(Visited),
        list_check_place(chansons, hub_reve, 0, Visited),
        %%% HR_F_02
        write("La porte menant au feu de camp a disparu..."), nl.
        
deplacer(galeries, galeries, 0) :-
        visited(Visited),
        list_check_place(galeries, hub_reve, 0, Visited),
        %%% HR_F_04
        write("La porte menant aux galeries a disparu..."), nl.

deplacer(ruisseau, ruisseau, 0) :-
        cutList(Cut),
        \+ list_check_place(ronces, foret, 0, Cut),
        %%% FR_F_39
        write("Il faut trouver un moyen de franchir le ruisseau pour faire cela."), nl.

deplacer(couloir, couloir, 0) :-
        interactedList(Interacted),
        \+ list_check_place(gerald, galeries, 0, Interacted),
        write("Il faut que je parle a [gerald] afin de savoir ce que je fais ici."), nl.

deplacer(couloir, couloir, 0) :-
        inventory(InventoryList),
        \+ list_check_inventory("Pelle", InventoryList),
        write("Mieux vaut prendre la [pelle] avant de partir en exploration..."), nl.

deplacer(foret, foret, 1) :-
        interactedList(Interacted),
        \+ list_check_place(traces, campement, 1, Interacted),
        write("Une foret ? Quelle foret ? Je ne vois pas de foret moi."), nl.

deplacer(foret, foret, 1) :-
        visited(Visited),
        list_check_place(foret, campement, 1, Visited),
        write("Les loups vous attraperaient, cela ne servirait a rien..."), nl.

deplacer(maison, maison, 1) :-
        cutList(Cut),
        \+ list_check_place(ronces, foret, 1, Cut),
        write("Des [ronces] vous empechent d'aller plus loin !"), nl.

deplacer(ruisseau, ruisseau, 1) :-
        inventory(InventoryList),
        \+ list_check_inventory("Hache", InventoryList),
        \+ list_check_inventory("Baton", InventoryList),
        write("Il vous faut d'abord choisir une arme pour vous defendre !"), nl.

% Dans le cas ou le nom ou nous allons et celui rentre en direction est le meme
deplacer(Direction, La, Cauchemar) :-
        equal(Direction, La),
        description(Direction, Cauchemar),
        retract(position_courante(Ici)),
        assert(position_courante(Direction)),
        visited(Visited),
        list_add([Direction, Ici, Cauchemar], Visited, NewList),
        retract(visited(_)),
        assert(visited(NewList)).
        
% Dans l'autre cas
deplacer(Direction, La, Cauchemar) :-
        description(Direction, Cauchemar),
        retract(position_courante(Ici)),
        assert(position_courante(La)),
        description(La, Cauchemar),
        visited(Visited),
        list_add([La, Ici, Cauchemar], Visited, NewList),
        retract(visited(_)),
        assert(visited(NewList)).


retour :-
        position_courante(Ici),
        cauchemar(Cauchemar),
        retour(Ici, Avant, Cauchemar),
        description(Avant, Cauchemar),
        retract(position_courante(Ici)),
        assert(position_courante(Avant)),
        !.

retour :-
        write("Ou voulez-vous retourner ? Vous etes deja au centre de cet endroit."), nl,
        fail.

carnet(X) :-
        lire(X).

suiv :-
        dernierePage(Last),
        \+ equal(Last, 3),
        increase(Last, New),
        retract(dernierePage(Last)),
        assert(dernierePage(New)),
        lire(New),
        !.

suiv :-
        write("Vous etes deja a la fin du carnet !"), nl,
        fail.

prev :-
        dernierePage(Last),
        \+ equal(Last, 1),
        decrease(Last, New),
        retract(dernierePage(Last)),
        assert(dernierePage(New)),
        lire(New),
        !.

prev :-
        write("Vous etes deja au debut du carnet !"), nl,
        fail.

% fin de partie
fin :-
        nl, write("La partie est finie."), nl,
        halt.


% affiche les instructions du jeu
instructionsall :-
        write("Les mots encadres par des [] sont des objets a interactions. Vous pouvez essayer tout type d'action sur eux."), nl,
        write("Les mots entre {} sont les chemins possibles a suivre. N'hesitez pas a y aller en utilisant la commande adaptee."), nl, nl, 
        
        write("Les commandes doivent etre donnees avec la syntaxe Prolog habituelle."), nl,
        write("Les commandes existantes sont :"), nl, nl,

        write("jouer.                             -- pour commencer une partie."), nl,
        write("regarder. / r.                     -- pour regarder autour de vous (Repete le texte de zone)."), nl,
        write("aller(direction) / go {direction}. -- pour aller dans cette direction."), nl,
        write("retour. / b.                       -- pour retourner a l'endroit precedent/au centre de la piece."), nl,
        write("observer(objet). / o [objet].      -- pour regarder quelque chose."), nl,
        write("interagir(objet). / int [objet].   -- pour interagir avec quelque chose."), nl,
        write("inventaire. / inv.                 -- pour analyser votre inventaire"), nl.

instructions2 :-
        write("carnet(page). / c {page}.          -- pour lire les pages de votre carnet"), nl.

instructions3 :-
        write("couper(objet). / cut [objet].      -- pour couper un objet"), nl.

instructions4 :-
        write("creuser(objet). / cr [objet].      -- pour creuser au niveau de cet objet"), nl.

instructionfin :-
        write("instructions.                      -- pour revoir ce message !"), nl,
        write("fin.                               -- pour terminer la partie et quitter."), nl.

instructions :-
        inventory(InventoryList),
        list_check_inventory("Couteau", InventoryList),
        list_check_inventory("Pelle", InventoryList),
        nl,
        instructionsall,
        instructions2,
        instructions3,
        instructions4,
        instructionfin,
        nl.

instructions :-
        inventory(InventoryList),
        list_check_inventory("Pelle", InventoryList),
        nl,
        instructionsall,
        instructions2,
        instructions4,
        instructionfin,
        nl.

instructions :-
        inventory(InventoryList),
        list_check_inventory("Couteau", InventoryList),
        nl,
        instructionsall,
        instructions2,
        instructions3,
        instructionfin,
        nl.

instructions :-
        inventory(InventoryList),
        list_check_inventory("Carnet & Stylo", InventoryList),
        nl,
        instructionsall,
        instructions2,
        instructionfin,
        nl.

instructions :-
        nl,
        instructionsall,
        instructionfin,
        nl.



% lancer une nouvelle partie
jouer :-
        write("Notre jeu est un RPG Textuel vous demandant de realiser des actions en reflechissant par vous-meme."), nl,
        write("Les textes vous indiqueront plus precisement les actions possibles."), nl, nl,
        instructions, nl,
        write("Vous debloquerez probablement quelques commandes supplementaires au fur et a mesure de votre avancement..."), nl, nl, nl,
        position_courante(Ici),
        cauchemar(Cauchemar),
        description(Ici, Cauchemar),
        visited(Visited),
        list_add([Ici, hub_reve, Cauchemar], Visited, NewList),
        retract(visited(_)),
        assert(visited(NewList)),
        !.


%%%%%%%%%%%%%%%%%%%%%%%%% Description finales %%%%%%%%%%%%%%%%%%%%%%%%%
description(fin0, 2) :-
        write("La salle etrange semble encore se transformer... "), nl,
        write("Des murs se forment autour de vous et se reduisent, formant un grand couloir."), nl,
        write("'He ! Tu m'entends ? He ! Ne lache pas, s'il te plait, tiens bon !'"), nl,
        write("Une voix au loin semble vous appeler."), nl,
        write("En face de vous, dans ce grand couloir, se dresse, [misty], votre chat."), nl.

description(misty, 2) :-
        write("Misty vous fixe, avec de grands yeux ronds, assise, droite et immobile."), nl.

description(animal, 2) :-
        write("Comme Misty, l'animal vous regarde sans bouger, attendant votre action."), nl.

description(gerald, 2) :-
        write("Gerald, est debout devant vous, il vous fixe, avec un grand sourire, immobile."), nl.

description(loup, 2) :-
        write("Le loup vous observe egalement. Immobile, comme les autres... Il ne presente aucune animosite."), nl.

description(miroir, 2) :-
        write("Vous vous regardez dans le miroir... Etes-vous fier de vos actions ?"), nl.

%%%%%%%%%%%%%%%%%%%%%%%%% Emplacements chambre %%%%%%%%%%%%%%%%%%%%%%%%%
description(chambre, 0) :- 
        visited(Visited),
        list_check_place(chambre, hub_reve, 0, Visited),
        write("Vous etes toujours dans votre chambre. Vous y apercevez votre {lit}, qui semble tres moelleux..."), nl,
        write("Quelques livres sont poses sur votre {etagere}, n'attendant que vous pour les prendre et vous asseoir en face de votre {bureau} les lire."), nl,
        write("Le soleil levant eclaire legerement la {porte} de votre chambre.").

description(chambre, 0) :- 
        %%% CR_D0
        write("Le soleil se leve, amenant une douce eclaircie sur la {porte} de votre chambre."), nl, 
        write("Vous avez fait votre {lit}, celui-ci semble desormais si moelleux..."), nl,
        write("Mais, quelques livres sont poses sur votre {etagere}, n'attendant que vous pour les prendre et vous asseoir en face de votre {bureau} les lire."), nl, nl,

        write("Ou voulez-vous ALLER ?"), nl.

description(lit, 0) :-
        %%% CR_D1 
        write("Vous vous approchez du lit. Celui-ci semble moelleux et accueillant."), nl, 
        write("Misty, votre [chat], vous regarde avec des yeux ronds, semblant attendre quelque chose de vous."), nl, 
        write("Un [poster] est accroche sur le mur, au-dessus du lit."), nl, 
        write("Une petite [peluche] est posee a cote de votre oreiller."), nl.

description(etagere, 0) :-
        %%% CR_D2
        write("Vous vous approchez de l'etagere. Sur celle-ci il y a deux livres, un de [maths] et un de [logique]."), nl, 
        write("Un [origami] fait-main est egalement pose sur cette etagere."), nl.

description(bureau, 0) :-
        %%% CR_D3
        write("Vous vous approchez du bureau. Un [carnet] est mis en evidence au milieu de celui-ci. Une [photo] encadree est soutenu par une [figurine]."), nl.

description(porte, 0) :-
        interactedList(Interacted),
        list_check_place(chat, lit, 0, Interacted),
        inventory(InventoryList),
        list_check_inventory("Carnet & Stylo", InventoryList),
        %%% CR_OV
        write("Vous ouvrez la porte, et sortez de votre chambre."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Description objets chambre %%%%%%%%%%%%%%%%%%%%%%%%%
description(chat, 0) :-
        interactedList(Interacted),
        list_check_place(chat, lit, 0, Interacted),
        %%% CR_F_18
        write("Misty est partie en courant en dehors de la chambre."), nl.

description(chat, 0) :-
        %%% CR_F_01
        write("Misty, votre petit chat noir, se dresse sur le lit en vous observant. Elle miaule dans votre direction."), nl.

description(poster, 0) :-
        %%% CR_F_02
        write("C'est un poster du film 'Inception'. On y voit 6 personnages dans une ville distordue par la realite des reves."), nl.

description(peluche, 0) :-
        %%% CR_F_03
        write("Une peluche en forme de T-Rex que vous avez obtenu plus jeune, en allant a la fete foraine avec votre famille."), nl.

description(origami, 0) :-
        interactedList(Interacted),
        list_check_place(origami, etagere, 0, Interacted),
        %%% CR_F_05
        write("Un origami en forme de renard que vous avez realise durant une conference sur les origamis."), nl, 
        write("Vous etes fier de l'avoir remis a neuf."), nl.

description(origami, 0) :-
        %%% CR_F_19
        write("Un origami en forme de renard que vous avez realise durant une conference sur les origamis."), nl, 
        write("Celui-ci semble etre courbe au niveau du museau."), nl.

description(maths, 0) :-
        interactedList(Interacted),
        list_check_place(maths, etagere, 0, Interacted),
        %%% CR_F_21
        write("Non, plus jamais je ne le regarderai !"), nl.

description(maths, 0) :-
        %%% CR_F_07
        write("Le livre de Maths a pour titre 'Maths, Application et Algebre'."), nl,
        write("La poussiere l'envahit, il ne semble pas avoir ete ouvert depuis longtemps."), nl.

description(logique, 0) :-
        %%% CR_F_09
        write("Le livre de Logique a pour titre 'Logique, Illogique, et Demontrer par l'Absurdite'."), nl,
        write("Contrairement a son confrere, ce livre semble avoir ete achete recemment, il est en parfait etat."), nl.

description(photo, 0) :-
        %%% CR_F_11
        write("Un selfie de vous et vos amis, autour d'un superbe feu de camp dans la foret."), nl,
        write("La photo a ete mise dans un tres joli cadre afin de ne pas abimer ce precieux souvenir."), nl.

description(figurine, 0) :-
        %%% CR_F_13
        write("C'est une petite figurine poussiereuse en bois que vous avez trouve lors d'une expedition dans des galeries pour un projet scientifique. Elle represente un aigle."), nl.

description(carnet, 0) :-
        interactedList(Interacted),
        list_check_place(carnet, bureau, 0, Interacted),
        %%% CR_F_22
        write("Le carnet est dans votre sac desormais."), nl.

description(carnet, 0) :-
        %%% CR_F_15
        write("Un simple carnet que vous venez d'acheter, est pose sur le bureau."), nl,
        write("sur sa couverture se trouve un stylo qui vous a suivi toute votre vie"), nl,
        write("puisqu'il ne vous a jamais failli depuis le debut de vos etudes."), nl,
        write("En meme temps vous ne l'avez pas beaucoup utilise..."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Emplacements hub reve %%%%%%%%%%%%%%%%%%%%%%%%%
description(hub_reve, 0) :-
        visited(Visited),
        list_check_place(hub_reve, chambre, 0, Visited),
        %%% HR_D5
        write("Vous etes de retour dans l'etrange piece aux portes."), nl,
        write("- Celle d'ou proviennent les {chansons}."), nl,
        write("- Celle avec les bruits des {galeries}."), nl, nl,

        write("Ou voulez-vous ALLER ?"), nl.

description(hub_reve, 0) :-
        %%% HR_D0
        write("Vous vous retrouvez dans un endroit etrange... Semblant etre en dehors de notre monde."), nl,
        write("L'atmosphere, pour autant, est douce et legere, vous ne ressentez aucune crainte..."), nl,
        write("Vous ne paraissez pas surpris de ce que vous voyez. Comme si vous etiez deja venu ici."), nl,
        write("Vous decidez de faire le tour de la piece afin d'avoir une vue d'ensemble."), nl, nl,

        write("Vous y decouvrez deux nouvelles portes : "), nl,
        write("- En collant votre oreille a la premiere, vous y ecoutez des {chansons}."), nl,
        write("- Par de-la la seconde, vous percevez beaucoup d'echos, ainsi que des bruits de pelles et de pioches comme dans des {galeries}."), nl, nl,

        write("Malheureusement, la porte a votre chambre a disparu derriere vous... Il ne semble plus etre possible d'y aller."), nl, nl,

        write("Ou voulez-vous ALLER ?"), nl.

description(chansons, 0) :-
        visited(Visited),
        list_check_place(chansons, hub_reve, 0, Visited),
        write("Vous voici de retour autour du [feu]."), nl,
        write("Vous vous trouvez a la clairiere d'une magnifique {foret} doucement eclaircie par un rayon de [lune]."), nl,
        write("[mathieu], votre ami d'enfance, est toujours present."), nl,
        write("Le chant de [maxime] et les rires de vos amis, ainsi que la chaleur et la lumiere du [feu] vous rassure."), nl,
        write("[mathieu] repeta : "), nl,
        write("'On va manquer de quelques buches pour alimenter le [feu], tu peux aller nous en chercher dans la {foret} ? Trois buches suffiront je pense !'"), nl,
        write("Vous hochez la tete et vous vous levez... Mais... Vous avez une impression de deja-vu..."), nl.

description(chansons, 0) :-
        %%% HR_D1
        write("Vous ouvrez la porte dont proviennent les chansons."), nl, nl,

        write("'Hey mec ! Ca va ?'"), nl,
        write("A peine avoir franchi la porte, vous voila autour d'un [feu] avec vos amis."), nl,
        write("Vous vous trouvez a la clairiere d'une magnifique {foret} doucement eclaircie par un rayon de [lune]."), nl,
        write("[mathieu], votre ami d'enfance, vous redemande 'Ca va ? Tu avais l'air absent.'"), nl,
        write("Le chant de [maxime] et les rires de vos amis, ainsi que la chaleur et la lumiere du [feu] vous rassure."), nl,
        write("[mathieu] continua : "), nl,
        write("'On va manquer de quelques buches pour alimenter le [feu], tu peux aller nous en chercher dans la {foret} ? Trois buches suffiront je pense !'"), nl,
        write("Vous hochez la tete et vous vous levez... Mais... Vous avez une impression de deja-vu..."), nl,
        write("Mathieu vous fait signe : 'Attend ! Tiens ! Ca te sera utile pour (Couper) du bois et te deplacer en foret !'"), nl, nl,

        write("        *Vous obtenez 1x [Couteau]*"), nl, nl,

        write("Une nouvelle commande est apparue. N'hesitez pas a faire 'instructions.' pour la consulter"), nl,
        inventory(InventoryList),
        list_add(["Couteau", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).	

description(galeries, 0) :-
        visited(Visited),
        list_check_place(galeries, hub_reve, 0, Visited),
        write("Vous etes de retour au centre des galeries, la ou vous attend [gerald]."), nl, nl,
        write("Des [minerais] gisent sur les murs en quantite... Pose contre l'un d'entre eux, une [pelle], n'attendant qu'a etre prise."), nl,
        write("Par dela cette salle se trouve un grand {couloir}, menant a la suite des galeries."), nl.

description(galeries, 0) :-
        %%% HR_D3
        write("Vous ouvrez la porte dont provient les bruits de galeries."), nl, nl,
        
        write("Vos poumons manquent subitement d'air... Vos yeux s'habituent difficilement a l'obscurite..."), nl,
        write("Vous vous sentez lourd, en effet, vous remarquez etre grandement equipe : Tenue complete de securite, bottes comprises et meme"), nl,
        write("un casque a lampe frontale. Vous etes dans une galerie, en train de miner."), nl, nl,

        write("En regardant autour de vous, vous remarquez [gerald], sans meme vous etonner de connaitre son nom, il vous parrait familier."), nl,
        write("Des [minerais] gisent sur les murs en quantite... Pose contre l'un d'entre eux, une [pelle], n'attendant qu'a etre prise."), nl,
        write("Par dela cette salle se trouve un grand {couloir}, menant a la suite des galeries."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Description chansons %%%%%%%%%%%%%%%%%%%%%%%%%
description(foret, 0) :-
        write("Vous vous dirigez sans crainte vers la foret."), nl,
        write("Vous regardez autour de vous : "), nl,
        write("Face a vous, un {ruisseau} est partiellement bloque par des [ronces]."), nl,
        write("Sur la gauche, un {sentier} peu eclaire est present."), nl,
        write("Sur la droite, vous apercevez une petite {maison}."), nl.

description(sentier, 0) :-
        write("En marchant sur le sentier, vous remarquez que des [feuilles] couvrent le ciel etoile."), nl,
        write("Des [arbres] sont disposes tout le long du sentier et les [lianes] tombant de ceux-ci rendent le chemin difficile d'acces."), nl.

description(maison, 0) :-
        write("Vous vous dirigez vers cette maison semblant abandonne de part les nombreuses [branches] envahissant son interieur."), nl,
        write("Les quelques [fleurs] entourant toutes la maison releve un peu le niveau de ce paysage desole."), nl,
        write("Vous remarquez une superbe [hache], la, posee contre le mur, a l'entree de la maison."), nl.

description(ruisseau, 0) :-
        write("Vous arrivez proche de l'[eau] claire du ruisseau."), nl,
        write("Il ne semble pas possible de le traverser, cela vous decoit quelques instants... Il y a pourtant une buche de l'autre cote..."), nl,
        write("Un frele animal vous regarde brievement depuis l'autre cote du ruisseau."), nl,
        write("Vous constatez un grand [tronc] figurant a votre droite..."), nl.

description(mathieu, 0) :-
        write("Mathieu s'occupe meticuleusement du feu, regarde chaque braise virevolter, il semble passionne par ce spectacle."), nl.

description(maxime, 0) :-
        write("Maxime, arme de sa guitare, frappe du pied la pulsation, et chante a haute voix, entrainant toutes les personnes assises autour du feu a chanter aussi."), nl.

description(feu, 0) :-
        write("Le feu crepite tout en rongeant le bois. Sa douce chaleur vous rechauffe..."), nl.

description(lune, 0) :-
        write("La lune brille de doux rayons, eclairant partiellement toute la foret."), nl.

description(ronces, 0) :-
        cutList(Cut),
        list_check_place(ronces, foret, 0, Cut),
        write("Le passage vers le {ruisseau} est desormais accessible !"), nl. 

description(ronces, 0) :-
        write("Des ronces vous bloquent le passage, vous distinguez un ruisseau derriere celles-ci."), nl.

description(lianes, 0) :-
        write("L'une des lianes semble plus rigide que les autres, il ne semble cependant pas possible de les couper de part leurs nombre."), nl.

description(fruit, 0) :-
        cutList(Cut),
        list_check_place(fruit, sentier, 0, Cut),
        write("Vous avez deja coupe le fruit, il n'y a plus rien desormais."), nl. 

description(fruit, 0) :-
        write("Le fruit semble bien mur et juteux, vous ne trouverez pas de fruit d'aussi bonne qualitee au supermarche !"), nl.

description(arbres, 0) :-
        cutList(Cut),
        list_check_place(arbres, sentier, 0, Cut),
        write("Si vous coupez tout les arbres de ce sentier, vous denaturerez ce dernier..."), nl. 

description(arbres, 0) :-
        write("L'un des arbres semble avoir un tronc plus epais que les autres, cela pourrait servir de buche."), nl.

description(feuilles, 0) :-
        write("La couleur des feuilles annoncent que l'automne approche de part leurs magnifiques couleurs orangees."), nl.

description(hache, 0) :-
        write("Une grande et belle hache, tranchante et pratiquement neuve, un miracle dans un tel endroit, elle pourrait vous permettre de remplacer ce pauvre couteau."), nl.

description(fleurs, 0) :-
        write("De belles fleurs colorees sont eparpillees autour de la maison, la rendant bien plus accueillante malgre son aspect abandonne."), nl.

description(branches, 0) :-
        cutList(Cut),
        list_check_place(branches, maison, 0, Cut),
        write("Vous avez deja coupe la seule branche pouvant faire office de buche."), nl. 

description(branches, 0) :-
        write("Il y a tellement de branches ici... Vous avez l'embarras du choix ! L'une d'elle, suffisamment epaisse, pourrait servir de tronc pour le feu..."), nl.

description(eau, 0) :-
        write("L'eau du ruisseau semble tres claire, presque transparente, elle a l'air si bonne... Mais mieux vaut ne pas la gouter, par mesure de precaution."), nl.

description(tronc, 0) :-
        cutList(Cut),
        list_check_place(tronc, ruisseau, 0, Cut),
        write("Le tronc d'arbre est tombe au-dessus du ruisseau, vous offrant un pont peu pratique mais fonctionnel."), nl. 

description(tronc, 0) :-
        write("Ce tronc appartient a un arbre massif, vous pourriez alimenter le feu pour des generations... Malheureusement impossible a couper, ce n'est pas ce gabarit que vous recherchez."), nl.

description(buche, 0) :-
        cutList(Cut),
        list_check_place(tronc, ruisseau, 0, Cut),
        write("Un bout du tronc s'est casse lors de la chute, il peut etre parfait pour vous..."), nl.

description(buche, 0) :-
        write("Il faut trouver un moyen de franchir le ruisseau pour faire cela."), nl.

description(animal, 0) :-
        cutList(Cut),
        \+ list_check_place(tronc, ruisseau, 0, Cut),
        write("Il faut trouver un moyen de franchir le ruisseau pour faire cela."), nl.

description(animal, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 0),
        write("Le corps sans vie de la bete git au sol."), nl.

description(animal, 0) :-
        actions(Actions),
        check_if_positif(Actions, 0),
        write("Le petit lapin s'est enfui apres que vous l'ayez nourri."), nl.

description(animal, 0) :-
        write("Le petit animal ressemble a un lapineau, il est en train de boire dans le ruisseau, il ne vous a pas vu..."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Description galeries %%%%%%%%%%%%%%%%%%%%%%%%%
description(pelle, 0) :-
        write("Une grande pelle a manche rouge est posee sur un mur couvert de minerais multicolores."), nl.

description(gerald, 0) :-
        write("Gerald est un grand homme d'une trentaine d'annee, en tenue complete de securite, comme vous."), nl,
        write("Il a une jolie barbe et de grands yeux bleus. Il sourit gaiement, vous voyant l'observer de tout les recoins au lieu d'aller lui parler."), nl.

description(minerais, 0) :-
        write("Sans ces minerais, la grotte serait beaucoup plus fade, il y en a tellement qu'il serait impossible de tous les recolter a vous seul."), nl.

description(couloir, 0) :-
        creusageList(Creusage),
        list_check_place(friable, couloir, 0, Creusage),
        write("En vous dirigeant vers ce long couloir, vous remarquez plusieurs [toiles] d'araignee sur les murs."), nl,
        write("L'{escalier} que vous avez decouvert est encore tout poussiereux."), nl,
        write("En continuant a avancer, vous decouvrez un {passage} vers la salle suivante."), nl.

description(couloir, 0) :-
        write("En vous dirigeant vers ce long couloir, vous remarquez plusieurs [toiles] d'araignee sur les murs et qu'un de ceux-ci semble [friable]. "), nl,
        write("En continuant a avancer, vous decouvrez un {passage} vers la salle suivante."), nl.

description(passage, 0) :-
        write("Lorsque vous traversez le passage, vous arrivez dans une grande piece. Le sol parait friable..."), nl, 
        write("Au centre de cette piece, se trouve une pierre comportant un nombre de [joyaux] incroyable !"), nl,
        write("C'est un veritable tresor !"), nl.

description(escalier, 0) :-
        creusageList(Creusage),
        list_check_place(friable, couloir, 0, Creusage),
        interactedList(Interacted),
        list_check_place(dynamite, escalier, 0, Interacted),
        write("Apres l'explosion en bas de l'escalier, un [trou] s'est forme au niveau du mur."), nl,
        write("Une petite [statuette] est mise en evidence."), nl.

description(escalier, 0) :-
        creusageList(Creusage),
        list_check_place(friable, couloir, 0, Creusage),
        write("En descendant l'escalier, vous vous trouvez desormais dans une petite piece sombre."), nl,
        write("En y faisant le tour vous y decouvrez une [dynamite] incrustee dans le mur ainsi qu'une [statuette] mise en evidence."), nl.

description(escalier, 0) :-
        write("Un escalier ? Quel escalier ? Je ne vois aucun escalier ici... Juste un mur potentiellement creusable par une petite pelle..."), nl.

description(friable, 0) :-
        write("Le mur semble friable, il s'effrite tout seul, quelques coups de pelle devraient suffire a voir ce qu'il y a derriere..."), nl.

description(toiles, 0) :-
        write("Vous regardez meticuleusement l'une des toiles d'araignee... Mmh... Pas de doute... C'est une toile d'araignee."), nl.

description(joyaux, 0) :-
        write("Des rubis ! Des saphirs ! De l'or ! De l'emeraude ! Des diamants ! ... Plus vous observez cette pierre de joyaux, plus vous decouvrez de pierres precieuses dessus."), nl.

description(pioche, 0) :-
        write("Une pioche se cachait dans le seul coin de la piece que vous n'aviez pas regarde, heureusement que vous l'avez vu maintenant !"), nl.

description(dynamite, 0) :-
        interactedList(Interacted),
        list_check_place(dynamite, escalier, 0, Interacted),
        write("La dynamite a explose, ne laissant qu'un [trou] beant derriere son passage"), nl.

description(dynamite, 0) :-
        write("La dynamite est incruste dans le mur par un petit trou fait avec un outil special."), nl.

description(trou, 0) :-
        interactedList(Interacted),
        \+ list_check_place(dynamite, escalier, 0, Interacted),
        write("Un trou ? Quel trou ? Je ne vois qu'une dynamite prete a exploser..."), nl.

description(trou, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 1),
        write("Il n'y a plus rien ici, l'eboulement a detruit tout ce qui se trouvait de l'autre cote du trou."), nl.

description(trou, 0) :-
        write("Vous jetez un oeil dans le trou, vous ne voyez pas grand chose, a part un autre oeil de l'autre cote..."), nl.

description(statuette, 0) :-
        write("C'est une petite statuette poussiereuse en bois. Elle represente un aigle."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Description hub_cauchemar %%%%%%%%%%%%%%%%%%%%%%%%%
description(hub_cauchemar, 1) :-
        nl,
        write("Les [Fragments Etrange] brillent sous vos yeux, se mettent a flotter et se rapproche doucement les uns des autres..."), nl, 
        write("Ils se combinent !"), nl, nl,

        write("        *Vous obtenez 1x [Souvenir]*"), nl, nl,

        write("Un souvenir que vous aviez oublie. Et que vous aurez prefere ne pas vous rappeler."), nl, nl,

        write("De maniere presque instantanee, la piece etrange se metamorphose sous vos yeux."), nl,
        write("Une brume de couleur pourpre envahit la piece... Vous avez du mal a respirer."), nl,
        write("L'ambiance devient menacante. Vous avez un tres mauvais pressentiment."), nl, nl,

        write("Une seule {porte} s'offre a vous."), nl, 
        write("Cette fois, vous etes sur de n'etre JAMAIS venu ici."), nl,
        inventory(InventoryList),
        remove_list(["Fragment Etrange", 3], InventoryList, NewList),
        list_add(["Souvenir", 1], NewList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)).

description(campement, 1) :-
        interactedList(Interacted),
        list_check_place(tronc, ruisseau, 1, Interacted),
        write("Vous etes finalement de retour au campement."), nl,
        write("Mais vous entendez des grognements autour de vous..."), nl,
        write("Les [loups] sont la ! Ils vous ont encercle !"), nl,
        write("Vous reculez lentement en direction du [feu] de camp eteint..."), nl.

description(campement, 1) :-
        interactedList(Interacted),
        \+ list_check_place(tronc, ruisseau, 1, Interacted),
        position_courante(X),
        equal(X, campement),
        write("En vous approchant de la porte, vous remarquez Misty."), nl,
        write("Votre chat, assise et dressee tout en longueur, regarde la porte menacante."), nl,
        write("Elle se retourne vers vous, miaule comme pour vous souhaiter bonne chance, puis disparait."), nl, nl,

        write("Vous ouvrez la porte et entrez dans la piece..."), nl, nl,

        write("Vous vous retrouvez dans la foret ou a eu lieu le feu de camp, mais..."), nl,
        write("Il n'y a personne."), nl,
        write("Il n'y a que vous."), nl,
        write("La [pluie] fait rage, la foret n'a plus rien d'accueillant, vous ne vous sentez plus en securite."), nl,
        write("Pas une seule eclaircie de la lune ne vous offre ne serait-ce qu'un peu de lumiere dans cette nuit noire."), nl,
        write("Les grands arbres sont oppressant, vous commencez a stresser et a avoir du mal a respirer..."), nl,
        write("Quelques bruits dans les buissons, probablement de petits animaux, sont les seuls sons que vous entendez."), nl,
        write("Le [feu] de camp est eteint."), nl,
        write("Des [traces] suspectes sont presentes un peu partout autour du campement."), nl,
        !.

description(campement, 1) :-
        interactedList(Interacted),
        \+ list_check_place(tronc, ruisseau, 1, Interacted),
        position_courante(X),
        \+ equal(X, campement),
        write("Le chemin vers le campement se trouve de l'autre cote du ruisseau !"), nl,
        !.

description(porte, 1) :-
        nl.

%%%%%%%%%%%%%%%%%%%%%%%%% Description campement %%%%%%%%%%%%%%%%%%%%%%%%%
description(foret, 1) :-
        interactedList(Interacted),
        list_check_place(traces, campement, 1, Interacted),
        write("Vous courez en direction de la foret pour echapper aux loups. Il fait sombre, vous ne voyez que des [ronces] bloquant le chemin vers la {maison}. Il faut faire vite, les loups vous poursuivent !"), nl.

description(foret, 1) :-
        write("Vous etes trop petrifie par cette foret sombre pour y penetrer."), nl.

description(traces, 1) :-
        interactedList(Interacted),
        list_check_place(traces, campement, 1, Interacted),
        write("Vous n'avez pas le temps de faire ca ! Vous etes pourchassez par des loups ! Fuyez en direction de la {foret} !"), nl.

description(traces, 1) :-
        write("Des traces d'animaux, encore seche malgre la pluie, elles doivent etre tres recentes..."), nl.

description(feu, 1) :-
        inventory(InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Quelques braises chauffent encore le feu..."), nl,
        write("Ca ne sera pas suffisant pour faire fuir les loups !"), nl.

description(feu, 1) :-
        interactedList(Interacted),
        list_check_place(traces, campement, 1, Interacted),
        write("Vous n'avez pas le temps de faire ca ! Vous etes pourchassez par des loups ! Fuyez en direction de la {foret} !"), nl.

description(feu, 1) :-
        write("Le feu est encore tiede, les campeurs sont partis recemment... Des braises sont encore visibles, miraculeusement protegees de la pluie par quelques buches."), nl.

description(pluie, 1) :-
        interactedList(Interacted),
        list_check_place(traces, campement, 1, Interacted),
        write("Vous n'avez pas le temps de faire ca ! Vous etes pourchassez par des loups ! Fuyez en direction de la {foret} !"), nl.

description(pluie, 1) :-
        write("La pluie tombe fortement sur toute la foret... C'est surement pour ca que les campeurs sont partis."), nl.
                
description(loups, 1) :-
        interactedList(Interacted),
        list_check_place(tronc, ruisseau, 1, Interacted),
        write("Les loups vous devorent du regard, ils sont pret a vous sauter dessus a tout moment, il faut agir !"), nl.

description(loups, 1) :-
        write("Des loups ? Quel loups ? Je ne vois pas de loups moi."), nl.

description(maison, 1) :-
        write("En fuyant les loups, vous arrivez devant la maison."), nl,
        write("Vous recherchez un moyen de vous defendre : "), nl,
        write("- Une [hache] est posee sur le mur a l'entree."), nl,
        write("- Un grand [baton] epais se trouve a vos pieds"), nl, nl,

        write("Vous n'aurez le temps d'en recuperer qu'un des deux puis de fuir en direction du {ruisseau}, bloque par les [broussailles]"), nl.

description(ronces, 1) :-
        write("Des grandes ronces bloquent le passage vers la maison. C'est votre seul acces pour fuir les loups !"), nl.

description(ruisseau, 1) :-
        cutList(Cut),
        list_check_place(broussailles, maison, 1, Cut),
        write("Vous arrivez de l'autre cote du ruisseau !"), nl,
        write("Les loups se demenent pour passer a travers les broussailles, cela ne leur prendra pas longtemps."), nl,
        write("Le [courant] est fort, impossible d'y traverser a pied."), nl,
        write("Heureusement, le [tronc] que vous avez coupe semble toujours en place !"), nl.

description(ruisseau, 1) :-
        write("Le chemin est bloque par des [broussailles] !"), nl.

description(hache, 1) :-
        inventory(InventoryList),
        \+ list_check_inventory("Hache", InventoryList),
        \+ list_check_inventory("Baton", InventoryList),
        write("Cela semble etre la meme hache que vous avez utilise autrefois. Elle n'est pas en parfait etat."), nl.

description(hache, 1) :-
        write("Impossible ! Les loups ont deja depasse ce point, il faut avancer !"), nl.

description(baton, 1) :-
        inventory(InventoryList),
        \+ list_check_inventory("Hache", InventoryList),
        \+ list_check_inventory("Baton", InventoryList),
        write("Un simple baton a bout rond, pas pratique pour eliminer ses cibles."), nl.

description(baton, 1) :-
        write("Impossible ! Les loups ont deja depasse ce point, il faut avancer !"), nl.

description(broussailles, 1) :-
        write("Des broussailles menant de l'autre cote du ruisseau, si peu qu'on arrive a les traverser."), nl.

description(tronc, 1) :-
        write("Un gros tronc d'arbre qui est tombe, permettant de traverser le ruisseau avec un peu d'adresse."), nl.

description(courant, 1) :-
        write("Le courant du ruisseau est beaucoup trop fort, vous perdrez l'equilibre en une fraction de seconde si vous essayez de le traverser."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Interactions finales %%%%%%%%%%%%%%%%%%%%%%%%%
interaction(misty, 2) :-
        write("Vous tendez la main pour la caresser... mais elle disparait subitement."), nl,
        write("La voix au loin repete : 'Pense aux choses qui t'ont rendu heureux !'"), nl,
        write("..."), nl,
        write("Vous avancez dans le couloir..."), nl,
        write("..."), nl,
        write("Devant vous se dresse desormais le petit [animal] que vous avez rencontre dans la foret."), nl,
        retract(position_courante(_)),
        assert(position_courante(fin1)).

interaction(animal, 2) :-
        actions(Actions),
        check_if_negatif(Actions, 0),
        write("Vous tendez la main vers l'animal. Terrifie, il s'enfuit en courant !"), nl,
        write("'On est en train de le perdre !' - Cria une autre voix, au bout du couloir."), nl, nl,

        write("Vous avancez encore... Vous tombez face a [gerald]."), nl,
        retract(position_courante(_)),
        assert(position_courante(fin2)).

interaction(animal, 2) :-
        write("Vous tendez la main vers l'animal. Il se rapproche de vous et se laisse caresser."), nl,
        write("Puis il disparait d'un coup."), nl,
        write("'Ses constantes sont stables !' - Cria une autre voix, au bout du couloir."), nl, nl,

        write("Vous avancez encore... Vous tombez face a [gerald]."), nl,
        retract(position_courante(_)),
        assert(position_courante(fin2)).

interaction(gerald, 2) :-
        actions(Actions),
        check_if_negatif(Actions, 1),
        write("'Hey bonhomme ! Ca va ? C'est toi qui a tue mon pote ?!'"), nl,
        write("Gerald se jette sur vous, furieux ! Il disparait au moment de vous toucher."), nl, nl,

        write("Vous continuez dans ce sombre couloir... jusqu'a voir les yeux d'un [loup] dans l'obscurite."), nl,
        write("Celui-ci ne semble pas vouloir vous attaquer."), nl,
        retract(position_courante(_)),
        assert(position_courante(fin3)).

interaction(gerald, 2) :-
        write("'Hey bonhomme ! Ca va ? Richard va bien, il s'est remis de cette aventure."), nl,
        write("Merci de l'avoir secouru, heureusement que tu etais la !'"), nl,
        write("Gerald s'approche de vous, bras ouvert, pour vous caliner."), nl, 
        write("Au moment de vous toucher, il disparait."), nl, nl,

        write("Vous continuez dans ce sombre couloir... jusqu'a voir les yeux d'un [loup] dans l'obscurite."), nl,
        write("Celui-ci ne semble pas vouloir vous attaquer."), nl,
        retract(position_courante(_)),
        assert(position_courante(fin3)).

interaction(loup, 2) :-
        actions(Actions),
        check_if_negatif(Actions, 2),
        write("Vous lui sautez dessus, hache en main ?!"), nl,
        write("Vous le frappez, le coupez, le tordez, l'arrachez, le dechiquetez, ..."), nl,
        write("Votre visage est couvert du sang du pauvre loup."), nl,
        write("Celui-ci disparait."), nl, nl,

        write("Vous voila a la fin du couloir. Face a un [miroir]."), nl,
        retract(position_courante(_)),
        assert(position_courante(fin)).

interaction(loup, 2) :-
        write("Vous vous abaissez a son niveau et tendez la main... Le loup s'approche."), nl,
        write("Vous ne ressentez aucune crainte, et carressez lentement le loup en souriant."), nl,
        write("Le loup semble apprecier les carresses, et vous leche la main en retour."), nl, 
        write("Soudain, il disparait."), nl, nl,

        write("Vous voila a la fin du couloir. Face a un [miroir]."), nl,
        retract(position_courante(_)),
        assert(position_courante(fin)).

interaction(miroir, 2) :-
        actions(Actions),
        sumlist(Actions, Res),
        check_if_positif(Res),
        write("Vous approchez votre main du miroir, puis le touchez."), nl,
        write("Ce dernier rayonne... Vous vous sentez vous elever..."), nl,
        write("'Il reprend connaissance !', la voix du couloir semble de plus en plus proche !"), nl,
        write("'Accroche-toi a de bons souvenirs !'..."), nl,
        write("Vous repensez a tout ce que vous avez vecu..."), nl,
        write("Vous ne pouvez pas vous arreter la..."), nl, nl,

        write("Progressivement, tout autour de vous se met a briller, de plus en plus fort."), nl,
        write("Vous ne voyez plus rien, puis... seulement la lumiere d'une lampe..."), nl,
        write("La luminosite s'affaiblit et vous distinguez-"), nl, nl,

        write("'Oh putain gars ! On pensait qu'on t'avait perdu !' s'exclama Mathieu."), nl, nl,

        write("Vous regardez autour de vous et reconnaissez egalement Maxime, Gerald et Richard !"), nl,
        write("Votre chat, assis sur vos genoux, se dresse vers vous. Il vous regarde avec des yeux ronds."), nl,
        write("Miaule, comme s'il attendait une caresse. Vous lui faites sans broncher."), nl, nl,

        write("'Depuis ton accident, tu te trouvais dans le coma dans ce lit d'hopital' replique Richard."), nl, nl,

        write("Maxime explique : 'On s'occupait de ton chat depuis ce jour mais elle n'arretait pas de miauler."), nl,
        write("On s'est dit qu'elle avait peut etre envie de te voir.'"), nl,
        write("'Ce petit bonhomme a saute sur toi des qu'elle t'a vu et n'a pas arreter de miauler !' s'etonne Gerald."), nl,
        write("'Et en une dizaine de minutes, te voila reveille !' finit Mathieu."), nl, nl,

        write("Misty vous fixe, puis miaule une nouvelle fois."), nl,
        write("..."), nl,
        write("Merci, Misty."), nl,
        fin.

interaction(miroir, 2) :-
        write("Vous approchez votre main du miroir, puis le touchez."), nl,
        write("Ce dernier se fissure, votre reflet sourit, contrairement a vous."), nl,
        write("'On le perd !', la voix du couloir est de plus en plus lointaine..."), nl,
        write("'Accroche-toi a de bons souvenirs !'... 'Lesquels ?' repondit le reflet..."), nl, nl,

        write("Progressivement, tout autour de vous se met a disparaitre..."), nl,
        write("Le miroir, les murs, le sol, le toit, le couloir, ..."), nl,
        write("Puis vos pieds, vos mains, vos jambes et vos bras ..."), nl,
        write("Il ne reste plus que votre tete, plus que votre cerveau..."), nl,
        write("Votre conscien-..."), nl, nl,

        write("        *Vous n'avez pas reussi a vous reveiller.*"), nl,
        fin.
        

%%%%%%%%%%%%%%%%%%%%%%%%% Interactions chambre %%%%%%%%%%%%%%%%%%%%%%%%%
interaction(chat, 0) :-
        interactedList(Interacted),
        list_check_place(chat, lit, 0, Interacted),
        %%% CR_F_18
        write("Misty est partie en courant en dehors de la chambre."), nl.

interaction(chat, 0) :-
        %%% CR_O_02
        write("Vous caressez Misty, elle se met a ronronner et se colle a vous. En continuant de la caresser, vous remarquez quelque chose coince dans ses poils."), nl, nl,

        write("        *Vous obtenez 1x Fragment Etrange*"), nl, nl,

        write("Par malheur, vous lui avez tire des poils, Misty fait un bond et s'enfuit de la piece."), nl,
        write("Il faut partir a sa recherche !"), nl,
        inventory(InventoryList),
        list_add(["Fragment Etrange", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(poster, 0) :-
        %%% CR_F_16
        write("Vous vous approchez du poster de 'Inception'."), nl,
        write("Vous vous imaginez que les personnages de l'affiche se mettent a bouger."), nl,
        write("Cela vous rememore de bons souvenirs du film."), nl.

interaction(peluche, 0) :-
        %%% CR_F_04
        write("Vous serrez la peluche fort dans vos bras, qu'importe votre age, l'enfant en vous est heureux d'avoir fait ca et se sent determiner a continuer."), nl.


interaction(origami, 0) :-
        interactedList(Interacted),
        list_check_place(origami, etagere, 0, Interacted),
        %%% CR_F_06
        write("Vous admirez ce magnifique origami remis a neuf."), nl.

interaction(origami, 0) :-
        %%% CR_F_20
        write("Vous depliez le museau du petit renard, l'origami est a nouveau tout neuf."), nl.

interaction(maths, 0) :-
        interactedList(Interacted),
        list_check_place(maths, etagere, 0, Interacted),
        %%% CR_F_21
        write("Non, plus jamais je ne le toucherai !"), nl.

interaction(maths, 0) :-
        %%% CR_F_08
        write("Vous prenez le livre de Mathematiques de votre bibliotheque, et ouvrez au milieu de celui-ci."), nl,
        write("Une vision de nombreux symboles mathematiques vous agresse l'esprit !"), nl,
        write("Par reflexe de survie, vous refermez rapidement ce livre demoniaque et le rangez de nouveau sur l'etagere."), nl,
        write("Vous vous promettez de ne plus jamais y toucher."), nl.

interaction(logique, 0) :-
        %%% CR_F_10
        write("Ce livre edite par Pierre Hyvernat semble divin."), nl,
        write("Celui-ci vous a ouvert les yeux sur les differents aspects de notre monde."), nl,
        write("Desormais, vous arrivez a resonner de facon plus clair et obtiendrez plus de points au partiel de Logique arrivant la semaine prochaine."), nl.

interaction(photo, 0) :-
        %%% CR_F_12
        write("Vous vous rememorez l'ambiance de ce feu de camp. Le parfum des brochettes puis des chamallow pendant que vous vous racontiez diverses histoires, tantot droles, tantot terrifiantes."), nl,
        write("Une envie de refaire ce genre de soiree vous parvient a l'esprit pendant qu'une larme de nostalgie coule sur votre joue."), nl.

interaction(figurine, 0) :-
        %%% CR_F_14
        write("Vous essayez de nettoyer la figurine, sans succes. La poussiere dessus est trop incrustee."), nl,
        write("'Au moins elle est plus authentique !' est la pensee qui traverse votre esprit en ce moment."), nl.

interaction(carnet, 0) :-
        interactedList(Interacted),
        list_check_place(carnet, bureau, 0, Interacted),
        %%% CR_F_22
        write("Le carnet est dans votre sac desormais."), nl.

interaction(carnet, 0) :-
        %%% CR_V_01
        write("Vous decidez que ces ustensiles vous seront utiles pour aujourd'hui et les prenez avec vous."), nl, nl,

        write("        *Vous obtenez 1x [Carnet & Stylo]*"), nl, nl,

        write("Une nouvelle commande est apparue. N'hesitez pas a faire 'instructions.' pour la consulter"), nl,
        inventory(InventoryList),
        list_add(["Carnet & Stylo", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).


%%%%%%%%%%%%%%%%%%%%%%%%% Interactions chansons %%%%%%%%%%%%%%%%%%%%%%%%%
interaction(mathieu, 0) :-
        inventory(InventoryList),
        list_check_inventory("Buche", 3, InventoryList),
        list_check_inventory("Fragment Etrange", 1, InventoryList),
        write("'Ah ! Merci pour les buches ! On va pouvoir faire un super feu !'"), nl,
        write("''...'"), nl,
        write("'Ca va ? Tu n'as pas l'air dans ton assiette depuis tout a l'heure...'"), nl,
        write("'Tiens, regarde ce que j'ai trouve pendant que tu etais parti ! Ca va peut etre te remonter le moral, toi qui aime bien les trucs anciens !'"), nl,
        write("Mathieu vous tend un morceau de cristal."), nl, 
        write("'Qu'est-ce que ca peut etre a ton avis ?'"), nl, nl,

        write("        *Vous obtenez 1x [Fragment Etrange]*"), nl,

        write("'Alors qu'est-ce que tu en pens-'"), nl,
        write("Vous clignez des yeux, ... Puis... "),
        inventory(InventoryList),
        list_add(["Fragment Etrange", 1], InventoryList, NewList),
        remove_list(["Buche", 3], NewList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)),
        retract(position_courante(_)),
        assert(position_courante(hub_reve)),
        description(hub_reve, 0).

interaction(mathieu, 0) :-
        inventory(InventoryList),
        list_check_inventory("Buche", 3, InventoryList),
        list_check_inventory("Fragment Etrange", 2, InventoryList),
        write("'Ah ! Merci pour les buches ! On va pouvoir faire un super feu !'"), nl,
        write("''...'"), nl,
        write("'Ca va ? Tu n'as pas l'air dans ton assiette depuis tout a l'heure...'"), nl,
        write("'Tiens, regarde ce que j'ai trouve pendant que tu etais parti ! Ca va peut etre te remonter le moral, toi qui aime bien les trucs anciens !'"), nl,
        write("Mathieu vous tend un morceau de cristal."), nl, 
        write("'Qu'est-ce que ca peut etre a ton avis ?'"), nl, nl,

        write("        *Vous obtenez 1x [Fragment Etrange]*"), nl,

        write("'Alors qu'est-ce que tu en pens-' ... "),
        list_add(["Fragment Etrange", 1], InventoryList, NewList),
        remove_list(["Buche", 3], NewList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)),
        retract(cauchemar(_)),
        assert(cauchemar(1)),
        retract(position_courante(_)),
        assert(position_courante(hub_cauchemar)),
        visited(Visited),
        list_add([hub_cauchemar, hub_reve, 1], Visited, NewList3),
        retract(visited(_)),
        assert(visited(NewList3)),
        description(hub_cauchemar, 1).

interaction(mathieu, 0) :-
        write("'Oui ? Tu n'as pas encore recupere les 3 buches ? Il doit y en avoir encore dans la {foret}...'"), nl.

interaction(maxime, 0) :-
        write("'Soon may the Wellerman come !"), nl,
        write("To bring us sugar and tea and rum !"), nl,
        write("One day, when the tonguing is done !"), nl,
        write("We'll take our leave and go...'"), nl.

interaction(feu, 0) :-
        write("'C'est beaucoup trop chaud... Je n'y mettrais pas la main si j'etais toi !' replique Mathieu."), nl.

interaction(lune, 0) :-
        write("Vous observez le magnifique paysage que vous offre la lune sur ces bois. Cela vous rend, etrangement, nostalgique..."), nl.

interaction(ronces, 0) :-
        cutList(Cut),
        list_check_place(ronces, foret, 0, Cut),
        write("Le passage vers le {ruisseau} est desormais accessible !"), nl. 

interaction(ronces, 0) :-
        write("'Aie ! Ca pique...', ces ronces n'ont pas l'air tres solide pour autant."), nl.

interaction(lianes, 0) :-
        write("Vous decidez de grimper sur la liane la plus rigide et apercevez un [fruit] a portee de main !"), nl.

interaction(fruit, 0) :-
        cutList(Cut),
        list_check_place(fruit, sentier, 0, Cut),
        write("Vous avez deja coupe le fruit, il n'y a plus rien desormais."), nl. 

interaction(fruit, 0) :-
        write("Vous tentez d'attraper le fruit mais celui-ci semble bien accroche a l'arbre. Peut etre que couper le haut du fruit suffirait a le faire tomber..."), nl.

interaction(arbres, 0) :-
        cutList(Cut),
        list_check_place(arbres, sentier, 0, Cut),
        write("Si vous coupez tout les arbres de ce sentier, vous denaturerez ce dernier..."), nl. 

interaction(arbres, 0) :-
        write("En tentant d'arracher a main nue cet arbre, vous vous rendez compte que vous n'auriez pas du arreter votre abonnement a la salle de musculation si tot."), nl.

interaction(feuilles, 0) :-
        write("Vous prenez un paquet de feuilles et les jetez en avant."), nl,
        write("Ces dernieres se prennent dans la brise d'air et virevoltent dans tous les sens."), nl,
        write("Ces nuances de couleurs eclatantes melangees aux doux rayons de la lune vous offrent un spectacle memorable."), nl.

interaction(hache, 0) :-
        inventory(InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Vous avez deja recupere la hache."), nl.

interaction(hache, 0) :-
        write("Vous vous emparez de la hache, desormais vous pourrez coupez plus aisement !"), nl, nl,
        write("        *Vous obtenez 1x [Hache]*"), nl,
        inventory(InventoryList),
        list_add(["Hache", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(fleurs, 0) :-
        write("Vous cueillez une des fleurs et sentez son odeur... Un doux parfum vous fait fremir les narines !"), nl.

interaction(branches, 0) :-
        cutList(Cut),
        list_check_place(branches, maison, 0, Cut),
        write("Vous avez deja coupe la seule branche pouvant faire office de buche."), nl. 

interaction(branches, 0) :-
        write("Vous choisissez la branche la plus epaisse et tentez de la couper a la seule force de vos bras... qui vous font defaut."), nl.

interaction(eau, 0) :-
        write("Vous essayez de traverser le ruisseau mais le courant est si fort que vous avez failli perdre l'equilibre en n'y posant qu'un pied ! Impossible de traverser..."), nl.

interaction(tronc, 0) :-
        cutList(Cut),
        list_check_place(tronc, ruisseau, 0, Cut),
        write("Le tronc d'arbre est tombe au-dessus du ruisseau, vous offrant un pont peu pratique mais fonctionnel."), nl. 

interaction(tronc, 0) :-
        write("En touchant le tronc d'arbre, vous vous rendez compte qu'il n'est pas tres stable... En observant de plus pret, il a ete partiellement coupe a sa base ! Quelques coups supplementaires suffiront peut etre..."), nl.

interaction(buche, 0) :-
        interactedList(Interacted),
        list_check_place(buche, ruisseau, 0, Interacted),
        write("Vous avez deja recupere la buche."), nl.

interaction(buche, 0) :-
        inventory(InventoryList),
        list_check_inventory("Buche", 2, InventoryList),
        cutList(Cut),
        list_check_place(tronc, ruisseau, 0, Cut),
        write("Vous recuperez la buche pose a terre. C'etait d'une simplicite... deconcertante."), nl, nl,

        write("        *Vous obtenez 1x [Buche]*"), nl, nl,

        write("Vous constatez par malheur que vous avez perdu votre hache a ce moment-la..."), nl,
        inventory(InventoryList),
        list_add(["Buche", 1], InventoryList, NewList),
        remove_list(["Hache", 1], NewList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)).

interaction(buche, 0) :-
        cutList(Cut),
        list_check_place(tronc, ruisseau, 0, Cut),
        write("Vous recuperez la buche pose a terre. C'etait d'une simplicite... deconcertante."), nl, nl,

        write("        *Vous obtenez 1x [Buche]*"), nl,
        inventory(InventoryList),
        list_add(["Buche", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(animal, 0) :-
        cutList(Cut),
        \+ list_check_place(tronc, ruisseau, 0, Cut),
        write("Il faut trouver un moyen de franchir le ruisseau pour faire cela."), nl.

interaction(animal, 0) :-
        actions(Actions),
        check_if_positif(Actions, 0),
        write("Le petit lapin s'est enfui apres que vous l'ayez nourri."), nl.

interaction(animal, 0) :-
        inventory(InventoryList),
        list_check_inventory("Fruit", InventoryList),
        write("Vous tendez le fruit a l'animal... Il est craintif..."), nl,
        write("Vous posez le fruit a vos pieds puis reculez suffisamment."), nl,
        write("L'animal s'approche lentement... Et deguste le fruit devant vous !"), nl, nl,    

        write("        *Vous notez cette experience unique dans la PREMIERE PAGE de votre carnet*"), nl,
        actions(Actions),
        change_list(0, 1, Actions, NewList),
        retract(actions(_)),
        assert(actions(NewList)),
        remove_list(["Fruit", 1], InventoryList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)).

interaction(animal, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 0),
        write("Le corps sans vie de la bete git au sol."), nl.

interaction(animal, 0) :-
        write("Si vous vous approchez trop pret de l'animal, il pourrait s'enfuir, mieux vaut eviter et trouver quelque chose pour l'appater..."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Interactions galeries %%%%%%%%%%%%%%%%%%%%%%%%%
interaction(pelle, 0) :-
        inventory(InventoryList),
        list_check_inventory("Pelle", InventoryList),
        write("Vous avez deja recupere la pelle."), nl.

interaction(pelle, 0) :-
        write("Vous saisissez de vos mains cette magnifique pelle. Celle-ci est votre desormais. Pret a obeir a chacun de vos ordres, vous pouvez desormais (Creuser) certains murs ou minerais par exemple."), nl, nl,

        write("        *Vous obtenez 1x [Pelle]*"), nl, nl,

        write("Une nouvelle commande est apparue. N'hesitez pas a faire 'instructions.' pour la consulter"), nl,
        inventory(InventoryList),
        list_add(["Pelle", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(gerald, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 1),
        inventory(InventoryList),
        list_check_inventory("Fragment Etrange", 1, InventoryList),
        geraldMauvais,
        retract(position_courante(_)),
        assert(position_courante(hub_reve)),
        description(hub_reve, 0).    

interaction(gerald, 0) :-
        actions(Actions),
        check_if_positif(Actions, 1),
        inventory(InventoryList),
        list_check_inventory("Fragment Etrange", 1, InventoryList),
        geraldBon,
        retract(position_courante(_)),
        assert(position_courante(hub_reve)),
        description(hub_reve, 0).       

interaction(gerald, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 1),
        inventory(InventoryList),
        list_check_inventory("Fragment Etrange", 2, InventoryList),
        geraldMauvais,
        retract(cauchemar(_)),
        assert(cauchemar(1)),
        retract(position_courante(_)),
        assert(position_courante(hub_cauchemar)),
        description(hub_cauchemar, 1),
        visited(Visited),
        list_add([hub_cauchemar, hub_reve, 1], Visited, NewList3),
        retract(visited(_)),
        assert(visited(NewList3)).
                
interaction(gerald, 0) :-
        actions(Actions),
        check_if_positif(Actions, 1),
        inventory(InventoryList),
        list_check_inventory("Fragment Etrange", 2, InventoryList),
        geraldBon,
        retract(cauchemar(_)),
        assert(cauchemar(1)),
        retract(position_courante(_)),
        assert(position_courante(hub_cauchemar)),
        description(hub_cauchemar, 1),
        visited(Visited),
        list_add([hub_cauchemar, hub_reve, 1], Visited, NewList3),
        retract(visited(_)),
        assert(visited(NewList3)).        

interaction(gerald, 0) :-
        write("'Aaaaah ! Te voila enfin ! On a besoin de toi pour continuer a explorer nos galeries... On n'a plus de nouvelle de Richard depuis quelques minutes, ca nous inquiete pas mal, tu pourrais nous aider a le chercher ? Et si tu peux recuperer quelques pierres precieuses en meme temps, profites-en !'"), nl.

interaction(minerais, 0) :-
        write("Vous touchez quelques-uns de ces minerais, ils sont froids et raffraichissant, cela contraste bien avec la chaleur que vous ressentez sous toutes ces couches de vetements... Vous continuez a toucher des minerais jusqu'a vous en lasser et continuer votre exploration."), nl.

interaction(friable, 0) :-
        write("Vous posez votre pelle par terre et tentez de griffer le mur avec vos mains, apres tout, qui a besoin d'outil quand notre corps est si pratique ?"), nl.

interaction(toiles, 0) :-
        write("Vous balayez l'une des toiles d'araignee a coup de pelle ! Il en reste encore... vraiment beaucoup. Mieux vaut arreter d'essayer de faire du menage dans ces galeries."), nl.

interaction(joyaux, 0) :-
        write("Dur comme de la roche, cette pierre ne se cassera qu'a l'aide de votre pelle pour sur ! Vous pouvez neanmoins tester avec vos mains... Vous y arriverez un jour pour sur !"), nl.

interaction(pioche, 0) :-
        inventory(InventoryList),
        list_check_inventory("Pioche", InventoryList),
        write("Vous avez deja recupere la pioche."), nl.

interaction(pioche, 0) :-
        write("Vous recuperez la pioche, vous pouvez desormais detruire un plus gros mur ! Sur son dos il y est ecrit 'Made In China, Usage Unique'..."), nl, nl,
        
        write("        *Vous obtenez 1x [Pioche]*"), nl,
        inventory(InventoryList),
        list_add(["Pioche", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(dynamite, 0) :-
        interactedList(Interacted),
        list_check_place(dynamite, escalier, 0, Interacted),
        write("La dynamite a explose, ne laissant qu'un [trou] beant derriere son passage"), nl.

interaction(dynamite, 0) :-
        write("Vous allumez la dynamite et courez le plus loin possible !"), nl,
        write("BOOOOM !"), nl,
        write("En revenant sur les lieux, vous decouvrez un [trou] a l'endroit ou la dynamite a explose."), nl.

interaction(trou, 0) :-
        interactedList(Interacted),
        \+ list_check_place(dynamite, escalier, 0, Interacted),
        write("Un trou ? Quel trou ? Je ne vois qu'une dynamite prete a exploser..."), nl.

interaction(trou, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 1),
        write("Il n'y a plus rien ici, l'eboulement a detruit tout ce qui se trouvait de l'autre cote du trou."), nl.

interaction(trou, 0) :-
        write("'Hey ! C'est Richard ! Je suis coince ici ! Tu peux m'aider ?"), nl, 
        write("Il faudrait que tu ailles recuperer la [pioche] qui se trouve au passage, c'est la piece au-dessus de moi !"), nl,
        write("Reviens avec et tu pourras creuser ce trou dans le mur pour me liberer !'"), nl.

interaction(statuette, 0) :-
        write("L'heure n'est pas a la recolte, vous vous jurez de recuperer cette statuette avant de partir pour garder un souvenir de cette expedition."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Interactions campement %%%%%%%%%%%%%%%%%%%%%%%%%
interaction(traces, 1) :-
        interactedList(Interacted),
        list_check_place(traces, campement, 1, Interacted),
        write("Vous n'avez pas le temps de faire ca ! Vous etes pourchassez par des loups ! Fuyez en direction de la {foret} !"), nl.

interaction(traces, 1) :-
        write("Vous analysez de plus pres les traces d'animaux... Ce sont des traces de loups, ils ont l'air d'etre plusieurs..."), nl,
        write("Vous decidez de suivre les traces."), nl,
        write("Celles-ci se terminent au niveau d'un petit sentier, vous regardez au loin et apercevez plusieurs pupilles, brillantes dans le noir... Ce sont les loups ! Ils vous pourchassent !"), nl.

interaction(feu, 1) :-
        interactedList(Interacted),
        list_check_place(traces, campement, 1, Interacted),
        inventory(InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Quelques braises chauffent encore le feu..."), nl,
        write("Ca ne sera pas suffisant pour faire fuir les loups !"), nl.

interaction(feu, 1) :-
        interactedList(Interacted),
        list_check_place(traces, campement, 1, Interacted),
        inventory(InventoryList),
        list_check_inventory("Baton", InventoryList),
        write("Vous plongez votre baton dans le feu de camp... Les quelques braises suffirent a enflammer le bout de votre baton, le transformant en torche !"), nl,
        write("Vous agitez votre nouvelle torche devant les loups, qui craintif, s'enfuient !"), nl, nl,

        write("        *Vous notez cette experience unique dans la TROISIEME PAGE de votre carnet*"), nl, nl,

        write("En clignant des yeux, vous vous retrouvez, encore une fois, dans la piece etrange."), nl,
        actions(Actions),
        change_list(2, 1, Actions, NewList),
        retract(actions(_)),
        assert(actions(NewList)),
        retract(position_courante(_)),
        assert(position_courante(fin0)),
        retract(cauchemar(_)),
        assert(cauchemar(2)),
        description(fin0, 2). 


interaction(feu, 1) :-
        interactedList(Interacted),
        list_check_place(traces, campement, 1, Interacted),
        write("Vous n'avez pas le temps de faire ca ! Vous etes pourchassez par des loups ! Fuyez en direction de la {foret} !"), nl.

interaction(feu, 1) :-
        write("Vous soufflez sur les braises, esperant vous rechauffez un peu... Sans grand succes."), nl.


interaction(pluie, 1) :-
        interactedList(Interacted),
        list_check_place(traces, campement, 1, Interacted),
        write("Vous n'avez pas le temps de faire ca ! Vous etes pourchassez par des loups ! Fuyez en direction de la {foret} !"), nl.

interaction(pluie, 1) :-
        write("La pluie coulant sur votre peau est froide et desagreable. Vous n'avez aucun moyen de vous abritez. Vous tentez de vous couvrir, mais sans succes."), nl.

interaction(loups, 1) :-
        interactedList(Interacted),
        list_check_place(tronc, ruisseau, 1, Interacted),
        inventory(InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Vous sautez sur les loups arme de votre hache, tel un guerrier partant en bataille !"), nl,
        write("Vous esquivez le premier loup, parez le deuxieme avec votre hache et frappez d'un coup mortel le troisieme !"), nl,
        write("Un quatrieme loup vous fait perdre l'equilibre, un des animaux vous saute alors a la gorge !"), nl,
        write("Vous bloquez sa machoire avec votre hache... Qui... casse."), nl,
        write("Vous sentez vos entrailles se faire ouvrir et devorer par les loups..."), nl,
        write("Quand soudain... Vous clignez des yeux, et vous revoila dans la salle etrange, en vie, et meme pas blesse."), nl, nl,

        write("*Vous notez cette experience unique dans la TROISIEME PAGE de votre carnet*"), nl,
        actions(Actions),
        change_list(2, -1, Actions, NewList),
        retract(actions(_)),
        assert(actions(NewList)),
        retract(position_courante(_)),
        assert(position_courante(fin0)),
        retract(cauchemar(_)),
        assert(cauchemar(2)),
        description(fin0, 2). 

interaction(loups, 1) :-
        interactedList(Interacted),
        list_check_place(tronc, ruisseau, 1, Interacted),
        write("Vous tentez de les tenir a distance grace a votre baton."), nl,
        write("Ca semble fonctionner mais ce n'est qu'une solution temporaire..."), nl.

interaction(loups, 1) :-
        write("Des loups ? Quel loups ? Je ne vois pas de loups moi."), nl.

interaction(ronces, 1) :-
        write("Vous essayez d'arracher les ronces a la main mais celles-ci sont trop durs et piquantes, vous ne faites que vous blessez."), nl.

interaction(hache, 1) :-
        inventory(InventoryList),
        \+ list_check_inventory("Hache", InventoryList),
        \+ list_check_inventory("Baton", InventoryList),
        write("Vous saissisez la hache avant que les loups ne vous rattrapent !"), nl, nl,

        write("*Vous obtenez 1x [Hache]*"), nl,
        list_add(["Hache", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(hache, 1) :-
        write("Impossible ! Les loups ont deja depasse ce point, il faut avancer !"), nl.

interaction(baton, 1) :-
        inventory(InventoryList),
        \+ list_check_inventory("Hache", InventoryList),
        \+ list_check_inventory("Baton", InventoryList),
        write("Vous saissisez le baton avant que les loups ne vous rattrapent !"), nl, nl,

        write("*Vous obtenez 1x [Baton]*"), nl,
        list_add(["Baton", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(baton, 1) :-
        write("Impossible ! Les loups ont deja depasse ce point, il faut avancer !"), nl.

interaction(broussailles, 1) :-
        write("Impossible de passer a travers, les feuillages sont trop denses, il va vous falloir un outil !"), nl.

interaction(tronc, 1) :-
        write("Vous passez par le tronc pour traverser le ruisseau."), nl,
        write("Vous manquez de perdre l'equilibre sous le stress mais vous arrivez a vous en sortir indemne."), nl,
        write("Les loups sont bloques de l'autre cote. Certains d'entre eux decident de faire le tour."), nl,
        write("Vous n'etes pas encore sorti d'affaires..."), nl,
        write("Le chemin jusqu'au {campement} s'offre a vous afin d'etablir une nouvelle strategie."), nl.

interaction(courant, 1) :-
        write("'Impossible ! Les loups me rattraperaient si je perd l'equilibre ! Je ne peux pas tenter ca !'"), nl.

%%%%%%%%%%%%%%%%%%%%%%%%% Couper chansons %%%%%%%%%%%%%%%%%%%%%%%%%

couperTexte(ronces, 0) :-
        cutList(Cut),
        list_check_place(ronces, foret, 0, Cut),
        write("Le passage vers le {ruisseau} est desormais accessible !"), nl. 

couperTexte(ronces, 0) :-
        write("Vous assenez de grands coups de couteau dans ces pauvres ronces et degagez le passage vers le {ruisseau} !"), nl.

couperTexte(fruit, 0) :-
        cutList(Cut),
        list_check_place(fruit, sentier, 0, Cut),
        write("Vous avez deja coupe le fruit, il n'y a plus rien desormais."), nl. 

couperTexte(fruit, 0) :-
        write("Vous coupez le haut du fruit, ce dernier tombe par terre. Vous le recuperez, il vous servira peut etre plus tard !"), nl, nl,

        write("        *Vous obtenez 1x [Fruit]*"), nl,
        inventory(InventoryList),
        list_add(["Fruit", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

couperTexte(arbres, 0) :-
        inventory(InventoryList),
        list_check_inventory("Buche", 2, InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Vous assenez de grand coup de hache dans le tronc de l'arbre et arrivez aisement a le faire faillir."), nl, nl,

        write("        *Vous obtenez 1x [Buche]*"), nl, nl,

        write("Votre hache s'est malheuresement cassee sur le coup..."), nl,
        list_add(["Buche", 1], InventoryList, NewList),
        remove_list(["Hache", 1], NewList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)).

couperTexte(arbres, 0) :-
        inventory(InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Vous assenez de grand coup de hache dans le tronc de l'arbre et arrivez aisement a le faire faillir."), nl, nl,

        write("        *Vous obtenez 1x [Buche]*"), nl,
        list_add(["Buche", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

couperTexte(branches, 0) :-
        inventory(InventoryList),
        list_check_inventory("Buche", 2, InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Avec votre superbe hache, vous DETRUISEZ la base d'une des branches et la recuperez !"), nl, nl,

        write("        *Vous obtenez 1x [Buche]*"), nl, nl,

        write("Malheuresement, votre hache se casse sur le coup..."), nl,
        inventory(InventoryList),
        list_add(["Buche", 1], InventoryList, NewList),
        remove_list(["Hache", 1], NewList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)).

couperTexte(branches, 0) :-
        inventory(InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Avec votre superbe hache, vous DETRUISEZ la base d'une des branches et la recuperez !"), nl, nl,

        write("        *Vous obtenez 1x [Buche]*"), nl,
        inventory(InventoryList),
        list_add(["Buche", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

couperTexte(tronc, 0) :-
        cutList(Cut),
        list_check_place(tronc, ruisseau, 0, Cut),
        write("Le tronc d'arbre est tombe au-dessus du ruisseau, vous offrant un pont peu pratique mais fonctionnel."), nl. 

couperTexte(tronc, 0) :-
        inventory(InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Vous frappez a de nombreuses reprises le tronc... Il tremble... Puis se met a tomber !"), nl,
        write("Vous pouvez desormais acceder a l'autre cote du ruisseau, la ou se trouve une [buche] et un petit [animal] !"), nl.

couperTexte(animal, 0) :-
        cutList(Cut),
        list_check_place(animal, ruisseau, 0, Cut),
        write("Le corps sans vie de la bete git au sol."), nl.

couperTexte(animal, 0) :-
        write("Vous vous lancez brutalement sur l'animal et lui assenez plusieurs coups de couteaux, la bete hurle de douleur et agonise lentement au sol. Son sang coule dans le ruisseau."), nl, nl,

        write("        *Vous notez cette experience unique dans la PREMIERE PAGE de votre carnet*"), nl,
        actions(Actions),
        change_list(0, -1, Actions, NewList),
        retract(actions(_)),
        assert(actions(NewList)).


%%%%%%%%%%%%%%%%%%%%%%%%% Couper campement %%%%%%%%%%%%%%%%%%%%%%%%%
couperTexte(ronces, 1) :-
        write("Vous coupez les ronces a l'aide de votre couteau ! Le chemin vers la {maison} est libre !"), nl.

couperTexte(broussailles, 1) :-
        write("Vous vous frayez un chemin a travers les broussailles !"), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Creuser galeries %%%%%%%%%%%%%%%%%%%%%%%%%
creuserTexte(friable, 0) :-
        write("Vous creusez au niveau du mur qui vous semblait friable... et vous aviez vu juste ! Un nouvel {escalier} se revele sous vos yeux !"), nl.

creuserTexte(joyaux, 0) :-
        creusageList(Creusage),
        list_check_place(trou, escalier, 0, Creusage),
        write("Vous avez pris toutes les precautions necessaires, et ayant sauve Richard, vous pouvez facilement recuperer les joyaux presents sur la pierre."), nl,
        write("Ce que vous vous empressez de faire afin de vous en mettre plein les poches evidemment."), nl, nl,

        write("        *Faites un rapport de la situation a Gerald !*"), nl.

creuserTexte(joyaux, 0) :-
        creusageList(Creusage),
        list_check_place(joyaux, passage, 0, Creusage),
        write("Les joyaux ont disparus dans les debris, tout comme la piece, inexplorable."), nl,
        write("Retournez voir Gerald pour lui faire votre rapport."), nl.

creuserTexte(joyaux, 0) :-
        write("Dans l'empressement de votre decouverte, vous sautez sur la pierre aux joyaux. Assener votre premier coup de pelle et le sol se derobe sous vos pieds !"), nl,
        write("L'eboulement a totalement detruit la piece du dessous..."), nl, nl,

        write("        *Vous notez cette experience unique dans la DEUXIEME PAGE de votre carnet*"), nl, nl,

        write("*Faites un rapport de la situation a Gerald !*"), nl,
        actions(Actions),
        change_list(1, -1, Actions, NewList),
        retract(actions(_)),
        assert(actions(NewList)).

creuserTexte(trou, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 1),
        write("Il n'y a plus rien ici, l'eboulement a detruit tout ce qui se trouvait de l'autre cote du trou."), nl.

creuserTexte(trou, 0) :-
        inventory(InventoryList),
        list_check_inventory("Pioche", InventoryList),
        write("Grace a votre nouvelle pioche, vous arrivez assez aisement a ouvrir un passage pour laisser Richard sortir ! Votre mission est reussie ! Vous pouvez encore vous balader dans les galeries ou faire tout de suite votre rapport a [Gerald]."), nl, nl,

        write("        *Vous notez cette experience unique dans la DEUXIEME PAGE de votre carnet*"), nl, nl,

        write("Votre pioche se casse bien sur le coup... Les produits fabriques en Chine ne sont pas tres solides..."), nl,
        actions(Actions),
        change_list(1, 1, Actions, NewList),
        retract(actions(_)),
        assert(actions(NewList)),
        remove_list(["Pioche", 1], InventoryList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)).

%%%%%%%%%%%%%%%%%%%%%%%%% Pages carnet %%%%%%%%%%%%%%%%%%%%%%%%%
lire(1) :-
        actions(Actions),
        check_if_positif(Actions, 0),
        write("Souvenir positif de la salle du feu de camp."), nl, nl,

        write("J'ai pose un fruit devant un animal de l'autre cote d'un ruisseau."), nl,
        write("Celui-ci l'a deguste devant moi... Trop mignon !"), nl, nl,

        write("Page suivante avec 'suiv.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(1)),
        !.

lire(1) :-
        actions(Actions),
        check_if_negatif(Actions, 0),
        write("Souvenir negatif de la salle du feu de camp."), nl, nl,
        
        write("J'ai tue un animal, celui-ci s'est roule de douleur avant d'agoniser sur le sol..."), nl,
        write("Je ne sais pas ce qui m'a pris..."), nl, nl,

        write("Page suivante avec 'suiv.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(1)),
        !.

lire(1) :-
        write("Cette page est vide."), nl, nl,

        write("Page suivante avec 'suiv.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(1)),
        !.

lire(2) :-
        actions(Actions),
        check_if_positif(Actions, 1),
        write("Souvenir positif de la salle des galeries."), nl, nl,

        write("Ayant pris toutes les precautions necessaires, et ayant sauve Richard, j'ai pu facilement recuperer les joyaux presents sur la pierre."), nl,
        write("Je repars les poches pleines de joyaux !"), nl, nl,

        write("Page suivante avec 'suiv.'"), nl,
        write("Page precedente avec 'prev.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(2)),
        !.

lire(2) :-
        actions(Actions),
        check_if_negatif(Actions, 1),
        write("Souvenir negatif de la salle des galeries."), nl, nl,

        write("Dans l'empressement de la decouverte de joyaux, le sol s'est derobe sous mes pieds au premier coup de pelle..."), nl,
        write("L'eboulement a totalement detruit la piece du dessous... Gerald m'accuse d'avoir tue son ami..."), nl, nl,

        write("Page suivante avec 'suiv.'"), nl,
        write("Page precedente avec 'prev.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(2)),
        !.

lire(2) :-
        write("Cette page est vide."), nl, nl,

        write("Page suivante avec 'suiv.'"), nl,
        write("Page precedente avec 'prev.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(2)),
        !.

lire(3) :-
        actions(Actions),
        check_if_positif(Actions, 2),
        write("Souvenir 'positif' du campement."), nl, nl,

        write("J'ai reussi a repousse la meute de loups sans les blesser !"), nl,
        write("Le feu m'a permit de les effrayer !"), nl, nl,

        write("Page precedente avec 'prev.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(3)),
        !.

lire(3) :-
        actions(Actions),
        check_if_negatif(Actions, 2),
        write("Souvenir negatif du campement."), nl, nl,

        write("Apres un combat acharne contre les loups... Ma hache s'est cassee au moment ou j'affrontais le quatrieme loup..."), nl,
        write("J'avais l'impression de me faire devorer..."), nl, nl,

        write("Page precedente avec 'prev.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(3)),
        !.

lire(3) :-
        write("Cette page est vide."), nl, nl,

        write("Page precedente avec 'prev.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(3)),
        !.



%%%%%%%%%%%%%%%%%%%%%%%%% Fonction pour pas repeter les textes 40 fois %%%%%%%%%%%%%%%%%%%%%%%%%

geraldBon :-
        write("        *Vous expliquez a Gerald ce qu'il s'est passe*"), nl, nl,

        write("'Ahahah ! C'est passe de peu, hein Richard ?!'"), nl,
        write("'C'est sur, si le petit gars n'avait pas ete la, j'aurais pas donner chere de ma peau !' repliqua-t-il."), nl, 
        write("'Je te dois une belle chandelle bonhomme ! Tiens, c'est peu par rapport au prix de ma vie, mais j'avais trouve ca durant mes fouilles'"), nl, 
        write("Richard vous tend un mysterieux objet..."), nl, nl,

        write("        *Vous obtenez 1x [Fragment Etrange]*"), nl, nl,

        write("'Bon, c'est pas tout ca, on va manger ? Ces mesaventures m'ont ouvert l'a-'"), nl,
        write("Vous clignez des yeux... Et... "),
        inventory(InventoryList),
        list_add(["Fragment Etrange", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

geraldMauvais :-
        write("        *Vous expliquez a Gerald ce qu'il s'est passe*"), nl, nl,

        write("'Je vois, ce n'est pas ta faute, tu ne pouvais pas savoir ce qui allait se passer..."), nl,
        write("Ecoute, mes gars et moi, on va degager tout ce foutoir et on revient vers toi apres..."), nl, 
        write("J'ai besoin d'etre un peu seul.'"), nl, nl,

        write("        ** Quelques heures plus tard **"), nl, nl,

        write("'Bon, malheureusement, on a bien retrouve Richard sous les decombres..."), nl,
        write("On a egalement trouve ca, on ne sait pas ce que c'est, ca te dit quelque chose ?'"), nl,
        write("Gerald vous tend un mysterieux objet... A peine vous le touchez que... vous etes de retour dans la salle etrange."), nl, nl,

        write("        *Vous obtenez 1x [Fragment Etrange]*"), nl,
        inventory(InventoryList),
        list_add(["Fragment Etrange", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).
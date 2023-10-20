%%% INFO-501, TP3
%%% Pierre Hyvernat
%%%
%%% Lancez la "requête"
%%% jouer.
%%% pour commencer une partie !
%

% il faut déclarer les prédicats "dynamiques" qui vont être modifiés par le programme.
:- dynamic position_courante/1.

% on remet à jours les positions des objets et du joueur
:- retractall(position(_, _)), retractall(position_courante(_)).

% position du joueur. Ce prédicat sera modifié au fur et à mesure de la partie (avec `retract` et `assert`)
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
actions([0,0,0,0]).

:- dynamic cauchemar/1.
cauchemar(0).

% passages entre les différents endroits du jeu
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

passage(hub_cauchemar, campement, campement, 1).
passage(campement, foret, foret, 1).
passage(maison, ruisseau, ruisseau, 1).
passage(ruisseau, campement, campement, 1).

passage(hub_cauchemar, galeries, galeries).
%passage(hub_cauchemar, chambre, chambre).

% RETOURS
retour(lit, chambre). 
retour(etagere, chambre). 
retour(bureau, chambre).

retour(chansons, hub_reve). 
retour(foret, chansons).
retour(sentier, foret).
retour(maison, foret).
retour(ruisseau, foret).

retour(galeries, hub_reve). 
retour(couloir, galeries).
retour(passage, couloir).
retour(escalier, couloir).

retour(campement, hub_cauchemar).
retour(galeries, hub_cauchemar).

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
position(liane, sentier, 0).
position(fruit, sentier, 0).
position(arbre, sentier, 0).
position(feuille, sentier, 0).
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
position(toile, couloir, 0).
position(joyaux, passage, 0).
position(pioche, passage, 0).
position(dynamite, escalier, 0).
position(trou, escalier, 0).
position(statuette, escalier, 0).

position(traces, campement, 1).
position(feu, campement, 1).
position(lune, campement, 1).
position(ronces, foret, 1).
position(hache, maison, 1).
position(baton, maison, 1).
position(broussailles, maison, 1).
position(tronc, ruisseau, 1).
position(courant, ruisseau, 1).

% objets pouvants être coupés
coupage(ronces).
coupage(arbre).
coupage(fruit).
coupage(branches).
coupage(tronc).
coupage(animal).

% objets pouvants être creusés
creusage(friable).
creusage(joyaux).
creusage(trou).


increase(X, X1) :-
        X1 is X+1.

decrease(X, X1) :-
        X1 is X-1.

equal(X,Y) :-
        X == Y.

check_if_positif(Liste, Num) :-
        nth0(Num, Liste, Element),
        Element > 0.

check_if_positif(Num) :-
        Num > 0.

check_if_negatif(Liste, Num) :-
        nth0(Num, Liste, Element),
        Element < 0.

check_if_negatif(Num) :-
        Num < 0.

change_list(Index, NewVal, List, NewList) :-
        nth0(Index, List, _, TempList),
        nth0(Index, NewList, NewVal, TempList).

somme([H|T], S) :- somme(T,X), S is H + X.

% Ajouter dans l'inventaire si l'item existe déjà
list_add(Name, OldList, NewList):-
        nth0(0, Name, Element), %Récupération du nom de l'item
        list_check_inventory(Element, OldList), %Check s'il existe dans l'inventaire
        indexOf(OldList, [Element, _], Index), %Trouve son index
        nth0(1, Name, Ajout), %Récupère le nombre qu'on ajoute à l'item
        nth0(Index, OldList, AncienElem), %Récupère l'ancien item dans la liste
        nth0(1, AncienElem, Base), %Récupère le nombre d'items qu'il y a de base
        NewNumber is Base + Ajout, %Ajoute les 2
        change_list(Index, [Element, NewNumber], OldList, NewList). %Remplace l'ancien nombre par le nouveau

% Ajouter dans une liste si ça existe pas déjà
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
        write("Je ne vois pas de "),
        write(X),
        write(" ici. Allez-vous vraiment bien ?"), nl,
        fail.


% interagir avec quelque chose
interagir(X) :-
        position_courante(P),
        cauchemar(Cauchemar),
        position(X, P, Cauchemar),
        interaction(X, Cauchemar), nl,
        interactedList(Interacted),
        list_add([X, P, Cauchemar], Interacted, NewList),
        retract(interactedList(_)),
        assert(interactedList(NewList)),
        !.

interagir(X) :-
        write("Je ne vois pas de "),
        write(X),
        write(" ici. Allez-vous vraiment bien ?"), nl,
        fail.


% couper quelque chose
couper(X) :-
        position_courante(P),
        coupage(X),
        cauchemar(Cauchemar),
        couperTexte(X, Cauchemar), nl,
        cutList(Cut),
        list_add([X, P, Cauchemar], Cut, NewList),
        retract(cutList(_)),
        assert(cutList(NewList)),
        !.

couper(X) :-
        write("Je ne vois pas de "),
        write(X),
        write(" ici. Qu'essayez-vous donc de couper ?"), nl,
        fail.

% creuser quelque chose
creuser(X) :-
        position_courante(P),
        creusage(X),
        cauchemar(Cauchemar),
        creuserTexte(X, Cauchemar), nl,
        creusageList(Creusage),
        list_add([X, P, Cauchemar], Creusage, NewList),
        retract(creusageList(_)),
        assert(creusageList(NewList)),
        !.

creuser(X) :-
        write("Je ne vois pas de "),
        write(X),
        write(" ici. Qu'essayez-vous donc de creuser ?"), nl,
        fail.


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
	nl, write("Vous possédez : "), nl,
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

% on déclare des opérateurs, pour autoriser `prendre torche` au lieu de `prendre(torche)`
:- op(1000, fx, observer).
:- op(1000, fx, interagir).
:- op(1000, fx, aller).
:- op(1000, fx, carnet).
:- op(1000, fx, couper).
:- op(1000, fx, creuser).

% déplacements
aller(porte) :-
        inventory(InventoryList),
        \+ list_check_inventory("Carnet & Stylo", InventoryList),
        %%% CR_F_23
        write("Vous ne pouvez pas sortir sans prendre votre carnet !"), nl, nl,
        position_courante(Ici),
        cauchemar(Cauchemar),
        description(Ici, Cauchemar), 
        !.

aller(porte) :-
        interactedList(Interacted),
        \+ list_check_place(chat, lit, 0, Interacted),
        %%% CR_F_17
        write("Vous mettez la main sur la poignée, votre chat miaule et demande une caresse, mieux vaut lui dire au revoir avant de partir."), nl, nl,
        position_courante(Ici),
        cauchemar(Cauchemar),
        description(Ici, Cauchemar), 
        !.

aller(chansons) :-
        visited(Visited),
        list_check_place(chansons, hub_reve, 0, Visited),
        %%% HR_F_02
        write("La porte menant au feu de camp a disparu..."), nl,
        !.
        
aller(galeries) :-
        visited(Visited),
        list_check_place(galeries, hub_reve, 0, Visited),
        %%% HR_F_04
        write("La porte menant aux galeries a disparu..."), nl,
        !.

aller(ruisseau) :-
        cutList(Cut),
        \+ list_check_place(ronces, foret, 0, Cut),
        %%% FR_F_39
        write("Il faut trouver un moyen de franchir le ruisseau pour faire cela."), nl.

aller(couloir) :-
        interactedList(Interacted),
        \+ list_check_place(gerald, galeries, 0, Interacted),
        write("Il faut que je parle à [Gérald] afin de savoir ce que je fais ici."), nl.

aller(couloir) :-
        inventory(InventoryList),
        \+ list_check_inventory("Pelle", InventoryList),
        write("Mieux vaut prendre la [Pelle] avant de partir en exploration..."), nl.

%%%%% CAS HUB reve %%%%%
% Dans le cas où le nom où nous allons et celui rentré en direction est le même
aller(Direction) :-
        cauchemar(Cauchemar),
        equal(Cauchemar, 0),
        description(Direction, Cauchemar),
        position_courante(Ici),
        passage(Ici, Direction, La, Cauchemar),
        equal(Direction, La),
        retract(position_courante(Ici)),
        assert(position_courante(La)),
        visited(Visited),
        list_add([Direction, Ici, Cauchemar], Visited, NewList),
        retract(visited(_)),
        assert(visited(NewList)),
        !.
        
% Dans l'autre cas
aller(Direction) :-
        cauchemar(Cauchemar),
        equal(Cauchemar, 0),
        position_courante(Ici),
        passage(Ici, Direction, La, Cauchemar),
        description(Direction, Cauchemar), nl,
        retract(position_courante(Ici)),
        assert(position_courante(La)),
        visited(Visited),
        cauchemar(Cauchemar),
        list_add([Direction, La, Cauchemar], Visited, NewList),
        retract(visited(_)),
        assert(visited(NewList)),
        description(La, Cauchemar),
        !.


aller(_) :-
        write("Où essayez vous d'aller ? Cet endroit n'existe pas."), nl,
        fail.


retour :-
        position_courante(Ici),
        retour(Ici, Avant),
        cauchemar(Cauchemar),
        description(Avant, Cauchemar),
        retract(position_courante(Ici)),
        assert(position_courante(Avant)),
        !.

retour :-
        write("Où voulez-vous retourner ? Vous êtes déjà au centre de cet endroit."), nl,
        fail.

carnet(X) :-
        lire(X).

suiv :-
        dernierePage(Last),
        increase(Last, New),
        \+ equal(New, 5),
        retract(dernierePage(Last)),
        assert(dernierePage(New)),
        lire(New),
        !.

suiv :-
        write("Vous êtes déjà à la fin du carnet !"), nl,
        fail.

prev :-
        dernierePage(Last),
        decrease(Last, New),
        \+ equal(New, 0),
        retract(dernierePage(Last)),
        assert(dernierePage(New)),
        lire(New),
        !.

prev :-
        write("Vous êtes déjà au début du carnet !"), nl,
        fail.

% fin de partie
fin :-
        nl, write("La partie est finie."), nl,
        halt.


% affiche les instructions du jeu
instructionsall :-
        write("Les mots encadrés par des [] sont des objets interagissables. Vous pouvez essayer tout type d'action sur eux, mais soyez logique."), nl,
        write("Les mots entre {} sont les chemins possibles à suivre. N'hésitez pas à y alelr en utilisant la commande adaptée."), nl, nl, 
        
        write("Les commandes doivent être données avec la syntaxe Prolog habituelle."), nl,
        write("Les commandes existantes sont :"), nl, nl,

        write("jouer.                             -- pour commencer une partie."), nl,
        write("regarder. / r.                     -- pour regarder autour de vous (Répète le texte précédent)."), nl,
        write("aller(direction) / go {direction}. -- pour aller dans cette direction."), nl,
        write("retour. / b.                       -- pour retourner à l'endroit précédent/au centre de la pièce."), nl,
        write("observer(objet). / o [objet].      -- pour regarder quelque chose."), nl,
        write("interagir(objet). / int [objet].   -- pour interagir avec quelque chose."), nl,
        write("inventaire. / inv.                 -- pour analyser votre inventaire"), nl.

instructions2 :-
        write("carnet(page). / c {page}.          -- pour lire les pages de votre carnet"), nl.

instructions3 :-
        write("couper(objet). / cut [objet].      -- pour couper un objet"), nl.

instructions4 :-
        write("creuser(objet). / cr [objet].      -- pour couper un objet"), nl.

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
        write("Notre jeu est un RPG Textuel vous demandant de réaliser des actions en réfléchissant par vous-même."), nl,
        write("Les textes vous indiqueront plus précisément les actions possibles."), nl, nl,
        instructions, nl,
        write("Vous débloquerez probablement quelques commandes supplémentaires au fur et à muesure de votre avancement..."), nl,
        position_courante(Ici),
        cauchemar(Cauchemar),
        description(Ici, Cauchemar),
        visited(Visited),
        list_add([Ici, hub_reve, Cauchemar], Visited, NewList),
        retract(visited(_)),
        assert(visited(NewList)),
        !.


description(fin, 2) :-
        actions(Actions),
        somme(Actions, Res),
        check_if_positif(Res),
        write("C'est la fin positive"), nl.

description(fin, 2) :-
        actions(Actions),
        somme(Actions, Res),
        check_if_negatif(Res),
        write("C'est la fin négative"), nl.
        
description(fin, 2) :-
        actions(Actions),
        somme(Actions, Res),
        equal(Res, 0),
        write("C'est la fin ??"), nl.

%%%%%%%%%%%%%%%%%%%%%%%%% Emplacements chambre %%%%%%%%%%%%%%%%%%%%%%%%%
description(chambre, 0) :- 
        visited(Visited),
        list_check_place(chambre, hub_reve, 0, Visited),
        write("Vous êtes toujours dans votre chambre. Vous y apercevez votre {lit}, qui semble très moelleux..."), nl,
        write("Quelques livres sont posés sur votre {etagere}, n'attendant que vous pour les prendre et vous asseoir en face de votre {bureau} les lire."), nl,
        write("Le soleil levant éclaire légèrement la {porte} de votre chambre.").

description(chambre, 0) :- 
        %%% CR_D0
        write("Le soleil se lève, amenant une douce éclaircie sur la {porte} de votre chambre."), nl, 
        write("Vous avez fait votre {lit}, celui-ci semble désormais si moelleux..."), nl,
        write("Mais, quelques livres sont posés sur votre {etagere}, n'attendant que vous pour les prendre et vous asseoir en face de votre {bureau} les lire."), nl, nl,

        write("Où voulez-vous ALLER ?"), nl.

description(lit, 0) :-
        %%% CR_D1 
        write("Vous vous approchez du lit. Celui-ci semble moelleux et accueillant."), nl, 
        write("Misty, votre [chat], vous regarde avec des yeux ronds, semblant attendre quelque chose de vous."), nl, 
        write("Un [poster] est accroché sur le mur, au-dessus du lit."), nl, 
        write("Une petite [peluche] est posée à côté de votre oreiller."), nl.

description(etagere, 0) :-
        %%% CR_D2
        write("Vous vous approchez de l'étagère. Sur celle-ci il y a deux livres, un de [Maths] et un de [Logique]."), nl, 
        write("Un [origami] fait-main est également posé sur cette étagère."), nl.

description(bureau, 0) :-
        %%% CR_D3
        write("Vous vous approchez du bureau. Un [carnet] est mis en évidence au milieu de celui-ci. Une [photo] encadrée est soutenu par un [triangle] peu commun."), nl.

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
        write("C'est un poster du film 'Inception'. On y voit 6 personnages dans une ville distordue par la réalité des rêves."), nl.

description(peluche, 0) :-
        %%% CR_F_03
        write("Une peluche en forme de T-Rex que vous avez obtenu plus jeune, en allant à la fête foraine avec votre famille."), nl.

description(origami, 0) :-
        interactedList(Interacted),
        list_check_place(origami, etagere, 0, Interacted),
        %%% CR_F_05
        write("Un origami en forme de renard que vous avez réalisé durant une conférence sur les origamis."), nl, 
        write("Vous êtes fier de l'avoir remis à neuf."), nl.

description(origami, 0) :-
        %%% CR_F_19
        write("Un origami en forme de renard que vous avez réalisé durant une conférence sur les origamis."), nl, 
        write("Celui-ci semble être courbé au niveau du museau."), nl.

description(maths, 0) :-
        %%% CR_F_07
        write("Le livre de Maths a pour titre 'Maths, Application et Algèbre'."), nl,
        write("La poussière l'envahit, il ne semble pas avoir été ouvert depuis longtemps."), nl.

description(logique, 0) :-
        %%% CR_F_09
        write("Le livre de Logique a pour titre 'Logique, Illogique, et Démontrer par l'Absurdité'."), nl,
        write("Contrairement à son confrère, ce livre semble avoir été acheté récemment, il est en parfait état."), nl.

description(photo, 0) :-
        %%% CR_F_11
        write("Un selfie de vous et vos amis, autour d'un superbe feu de camp dans la forêt."), nl,
        write("La photo a été mise dans un très joli cadre afin de ne pas abimer ce précieux souvenir."), nl.

description(figurine, 0) :-
        %%% CR_F_13
        write("Ce triangle est une représentation du triangle impossible en version miniaturisé. Vous l'avez obtenu durant une visite au musée des illusions."), nl.

description(carnet, 0) :-
        interactedList(Interacted),
        list_check_place(carnet, bureau, 0, Interacted),
        %%% CR_F_22
        write("Le carnet est dans votre sac désormais."), nl.

description(carnet, 0) :-
        %%% CR_F_15
        write("Un simple carnet que vous venez d'acheter, est posé sur le bureau, sur sa couverture se trouve un stylo qui vous a suivi toute votre vie puisqu'il ne vous a jamais failli depuis le début de vos études. En même temps vous ne l'avez pas beaucoup utilisé."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Emplacements hub reve %%%%%%%%%%%%%%%%%%%%%%%%%
description(hub_reve, 0) :-
        visited(Visited),
        list_check_place(chambre, hub_reve, 0, Visited),
        %%% HR_D5
        write("Vous êtes de retour dans l'étrange pièce aux portes."), nl,
        write("- Celle d'où proviennent les {chansons}."), nl,
        write("- Celle avec la voix du guide des {galeries}."), nl, nl,

        write("Où voulez-vous ALLER ?"), nl.

description(hub_reve, 0) :-
        %%% HR_D0
        write("Vous vous retrouvez dans un endroit étrange... Semblant être en dehors de notre monde."), nl,
        write("L'atmosphère, pour autant, est douce et légère, vous ne ressentez aucune crainte..."), nl,
        write("Vous ne paraissez pas surpris de ce que vous voyez. Comme si vous étiez déjà venu ici."), nl,
        write("Vous décidez de faire le tour de la pièce afin d'avoir une vue d'ensemble."), nl, nl,

        write("Vous y découvrez trois nouvelles portes : "), nl,
        write("- En collant votre oreille à la première, vous y écoutez des {chansons}."), nl,
        write("- Par de-là la seconde, vous percevez la voix d'un guide, beaucoup d'échos, ainsi que des bruits de pelles et de pioches comme dans des {galeries}."), nl, nl,

        write("Malheureusement, la porte à votre chambre a disparu derrière vous... Il ne semble plus être possible d'y aller."), nl, nl,

        write("Où voulez-vous ALLER ?"), nl.

description(chansons, 0) :-
        visited(Visited),
        list_check_place(chansons, hub_reve, 0, Visited),
        write("Vous voici de retour autour du [feu]."), nl,
        write("Vous vous trouvez à la clairière d'une magnifique {foret} doucement éclaircie par un rayon de [lune]."), nl,
        write("[Mathieu], votre ami d'enfance, est toujours présent."), nl,
        write("Le chant de [Maxime] et les rires de vos amis, ainsi que la chaleur et la lumière du [feu] vous rassure."), nl,
        write("[Mathieu] répéta : "), nl,
        write("'On va manquer de quelques buches pour alimenter le [feu], tu peux aller nous en chercher dans la {foret} ? Trois buches suffiront je pense !'"), nl,
        write("Vous hochez la tête et vous vous levez... Mais... Vous avez une impression de déjà-vu..."), nl.

description(chansons, 0) :-
        %%% HR_D1
        write("Vous ouvrez la porte dont proviennent les chansons."), nl, nl,

        write("'Hey mec ! Ca va ?'"), nl,
        write("A peine avoir franchi la porte, vous voilà autour d'un [feu] avec vos amis."), nl,
        write("Vous vous trouvez à la clairière d'une magnifique {foret} doucement éclaircie par un rayon de [lune]."), nl,
        write("[Mathieu], votre ami d'enfance, vous redemande 'Ca va ? Tu avais l'air absent.'"), nl,
        write("Le chant de [Maxime] et les rires de vos amis, ainsi que la chaleur et la lumière du [feu] vous rassure."), nl,
        write("[Mathieu] continua : "), nl,
        write("'On va manquer de quelques buches pour alimenter le [feu], tu peux aller nous en chercher dans la {foret} ? Trois buches suffiront je pense !'"), nl,
        write("Vous hochez la tête et vous vous levez... Mais... Vous avez une impression de déjà-vu..."), nl,
        write("Mathieu vous fait signe : 'Attend ! Tiens ! Ca te sera utile pour (Couper) du bois et te déplacer en fôret !'"), nl, nl,

        write("        *Vous obtenez 1x [Couteau]*"), nl, nl,

        write("Une nouvelle commande est apparue. N'hésitez pas à faire 'instructions.' pour la consulter"), nl,
        inventory(InventoryList),
        list_add(["Couteau", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).	

description(galeries, 0) :-
        visited(Visited),
        list_check_place(galeries, hub_reve, 0, Visited),
        write("Vous êtes de retour au centre des galeries, là où vous attend [Gérald]."), nl, nl,
        write("Des [minerais] gisent sur les murs en quantité... Posé contre l'un d'entre eux, une [pelle], n'attendant qu'à être prise."), nl,
        write("Par delà cette salle se trouve un grand {couloir}, menant à la suite des galeries."), nl.

description(galeries, 0) :-
        %%% HR_D3
        write("Vous ouvrez la porte dont provient la voix du guide."), nl, nl,
        
        write("Vos poumons manquent subitement d'air... Vos yeux s'habituent difficilement à l'obscurité..."), nl,
        write("Vous vous sentez lourd, en effet, vous remarquez être grandement équipé : Tenue complète de sécurité, bottes comprises et même"), nl,
        write("un casque à lampe frontale. Vous êtes dans une galerie, en train de miner."), nl, nl,

        write("En regardant autour de vous, vous remarquez [Gérald], sans même vous étonner de connaitre son nom, il vous parrait familier."), nl,
        write("Des [minerais] gisent sur les murs en quantité... Posé contre l'un d'entre eux, une [pelle], n'attendant qu'à être prise."), nl,
        write("Par delà cette salle se trouve un grand {couloir}, menant à la suite des galeries."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Description chansons %%%%%%%%%%%%%%%%%%%%%%%%%
description(foret, 0) :-
        write("Vous vous dirigez sans crainte vers la forêt."), nl,
        write("Vous regardez autour de vous : "), nl,
        write("Face à vous, un {ruisseau} est partiellement bloqué par des [ronces]."), nl,
        write("Sur la gauche, un {sentier} peu éclairé est présent."), nl,
        write("Sur la droite, vous apercevez une petite {maison}."), nl.

description(sentier, 0) :-
        write("En marchant sur le sentier, vous remarquez que des [feuilles] couvrent le ciel étoilé."), nl,
        write("Des [arbustes] sont disposés tout le long du sentier et les [lianes] tombant de ceux-ci rendent le chemin difficile d'accès."), nl.

description(maison, 0) :-
        write("Vous vous dirigez vers cette maison semblant abandonné de part les nombreuses [branches] envahissant son intérieur."), nl,
        write("Les quelques [fleurs] entourant toutes la maison relève un peu le niveau de ce paysage désolé."), nl,
        write("Vous remarquez une superbe [hache], là, posée contre le mur, à l'entrée de la maison."), nl.

description(ruisseau, 0) :-
        write("Vous arrivez proche de l'[eau] claire du ruisseau."), nl,
        write("Il ne semble pas possible de le traverser, celà vous déçoit quelques instants... Il y a pourtant une buche de l'autre côté..."), nl,
        write("Un frèle animal roux vous regarde brièvement depuis l'autre côté du ruisseau."), nl,
        write("Vous constatez un grand [tronc] figurant à votre droite..."), nl.

description(mathieu, 0) :-
        write("Mathieu s'occupe méticuleusement du feu, regarde chaque braise virevolter, il semble passionné par ce spectacle."), nl.

description(maxime, 0) :-
        write("Maxime, armé de sa guitare, frappe du pied la pulsation, et chante à haute voix, entrainant toutes les personnes assises autour du feu à chanter aussi."), nl.

description(feu, 0) :-
        write("Le feu crépite tout en rongeant le bois. Sa douce chaleur vous réchauffe..."), nl.

description(lune, 0) :-
        write("La lune brille de doux rayons, éclairant partiellement toute la forêt."), nl.

description(ronces, 0) :-
        cutList(Cut),
        list_check_place(ronces, foret, 0, Cut),
        write("Le passage vers le {Ruisseau} est désormais accessible !"), nl. 

description(ronces, 0) :-
        write("Des ronces vous bloquent le passage, vous distinguez un ruisseau derrière celles-ci."), nl.

description(lianes, 0) :-
        write("L'une des lianes semble plus rigide que les autres, il ne semble cependant pas possible de les couper de part leurs nombre."), nl.

description(fruit, 0) :-
        cutList(Cut),
        list_check_place(fruit, sentier, 0, Cut),
        write("Vous avez déjà coupé le fruit, il n'y a plus rien désormais."), nl. 

description(fruit, 0) :-
        write("Le fruit semble bien mûr et juteux, vous ne trouverez pas de fruit d'aussi bonne qualitée au supermarché !"), nl.

description(arbre, 0) :-
        cutList(Cut),
        list_check_place(arbre, sentier, 0, Cut),
        write("Si vous coupez tout les arbres de ce sentier, vous dénaturerez ce dernier..."), nl. 

description(arbre, 0) :-
        write("L'un des arbres semble avoir un tronc plus épais que les autres, cela pourrait servir de bûche."), nl.

description(feuille, 0) :-
        write("La couleur des feuilles annoncent que l'automne approche de part leurs magnifiques couleurs orangées."), nl.

description(hache, 0) :-
        write("Une grande et belle hache, tranchante et pratiquement neuve, un miracle dans un tel endroit, elle pourrait vous permettre de remplacer ce pauvre couteau."), nl.

description(fleurs, 0) :-
        write("De belles fleurs colorées sont éparpillées autour de la maison, la rendant bien plus accueillante malgré son aspect abandonné."), nl.

description(branches, 0) :-
        cutList(Cut),
        list_check_place(branches, maison, 0, Cut),
        write("Vous avez déjà coupé la seule branche pouvant faire office de buche."), nl. 

description(branches, 0) :-
        write("Il y a tellement de branches ici... Vous avez l'embarras du choix ! L'une d'elle, suffisamment épaisse, pourrait servir de tronc pour le feu..."), nl.

description(eau, 0) :-
        write("L'eau du ruisseau semble très claire, presque transparente, elle a l'air si bonne... Mais mieux vaut ne pas la gouter, par mesure de précaution."), nl.

description(tronc, 0) :-
        cutList(Cut),
        list_check_place(tronc, ruisseau, 0, Cut),
        write("Le tronc d'arbre est tombé au-dessus du ruisseau, vous offrant un pont peu pratique mais fonctionnel."), nl. 

description(tronc, 0) :-
        write("Ce tronc appartient à un arbre massif, vous pourriez alimenter le feu pour des générations... Malheureusement impossible à couper, ce n'est pas ce gabarit que vous recherchez."), nl.

description(buche, 0) :-
        cutList(Cut),
        list_check_place(tronc, ruisseau, 0, Cut),
        write("Un bout du tronc s'est cassé lors de la chute, il peut être parfait pour vous..."), nl.

description(buche, 0) :-
        write("Il faut trouver un moyen de franchir le ruisseau pour faire cela."), nl.

description(animal, 0) :-
        cutList(Cut),
        \+ list_check_place(tronc, ruisseau, 0, Cut),
        write("Il faut trouver un moyen de franchir le ruisseau pour faire cela."), nl.

description(animal, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 0),
        write("Le corps sans vie de la bête git au sol."), nl.

description(animal, 0) :-
        actions(Actions),
        check_if_positif(Actions, 0),
        write("Le petit lapin s'est enfui après que vous l'ayez nourri."), nl.

description(animal, 0) :-
        write("Le petit animal ressemble à un lapineau, il est en train de boire dans le ruisseau, il ne vous a pas vu..."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Description galeries %%%%%%%%%%%%%%%%%%%%%%%%%
description(pelle, 0) :-
        write("Une grande pelle à manche rouge est posée sur un mur couvert de minerais multicolores."), nl.

description(gerald, 0) :-
        write("Gérald est un grand homme d'une trentaine d'année, en tenue complète de sécurité, comme vous. Il a une jolie barbe et de grands yeux bleus. Il sourit gaiement, vous voyant l'observer de tout les recoins au lieu d'aller lui parler."), nl.

description(minerais, 0) :-
        write("Sans ces minerais, la grotte serait beaucoup plus fade, il y en a tellement qu'il serait impossible de tous les récolter à vous seul."), nl.

description(couloir, 0) :-
        creusageList(Creusage),
        list_check_place(friable, couloir, 0, Creusage),
        write("En vous dirigeant vers ce long couloir, vous remarquez plusieurs [toiles] d'araignée sur les murs."), nl,
        write("L'{escalier} que vous avez découvert est encore tout poussiéreux."), nl,
        write("En continuant à avancer, vous découvrez un {passage} vers la salle suivante."), nl.

description(couloir, 0) :-
        write("En vous dirigeant vers ce long couloir, vous remarquez plusieurs [toiles] d'araignée sur les murs et qu'un de ceux-ci semble [friable]. "), nl,
        write("En continuant à avancer, vous découvrez un {passage} vers la salle suivante."), nl.

description(passage, 0) :-
        write("Lorsque vous traversez le passage, vous arrivez dans une grande pièce. Le sol parait friable..."), nl, 
        write("Au centre de cette pièce, se trouve une pierre comportant un nombre de [joyaux] incroyable !"), nl,
        write("C'est un véritable trésor !"), nl.

description(escalier, 0) :-
        creusageList(Creusage),
        list_check_place(friable, couloir, 0, Creusage),
        interactedList(Interacted),
        list_check_place(dynamite, escalier, 0, Interacted),
        write("Après l'explosion en bas de l'escalier, un [trou] s'est formé au niveau du mur."), nl,
        write("Une petite [statuette] est mise en évidence."), nl.

description(escalier, 0) :-
        creusageList(Creusage),
        list_check_place(friable, couloir, 0, Creusage),
        write("En descendant l'escalier, vous vous trouvez désormais dans une petite pièce sombre."), nl,
        write("En y faisant le tour vous y découvrez une [dynamite] incrustée dans le mur ainsi qu'une [statuette] mise en évidence."), nl.

description(escalier, 0) :-
        write("Un escalier ? Quel escalier ? Je ne vois aucun escalier ici... Juste un mur potentiellement creusable par une petite pelle..."), nl.

description(friable, 0) :-
        write("Le mur semble friable, il s'éffrite tout seul, quelques coups de pelle devraient suffire à voir ce qu'il y a derrière..."), nl.

description(toile, 0) :-
        write("Vous regardez méticuleusement l'une des toiles d'araignée... Mmh... Pas de doute... C'est une toile d'araignée."), nl.

description(joyaux, 0) :-
        write("Des rubis ! Des saphirs ! De l'or ! De l'émeraude ! Des diamants ! ... Plus vous observez cette pierre de joyaux, plus vous découvrez de pierres précieuses dessus."), nl.

description(pioche, 0) :-
        write("Une pioche se cachait dans le seul coin de la pièce que vous n'aviez pas regardé, heureusement que vous l'avez vu maintenant !"), nl.

description(dynamite, 0) :-
        interactedList(Interacted),
        list_check_place(dynamite, escalier, 0, Interacted),
        write("La dynamite a explosé, ne laissant qu'un [trou] béant derrière son passage"), nl.

description(dynamite, 0) :-
        write("La dynamite est incrusté dans le mur par un petit trou fait avec un outil spécial."), nl.

description(trou, 0) :-
        interactedList(Interacted),
        list_check_place(dynamite, escalier, 0, Interacted),
        write("Un trou ? Quel trou ? Je ne vois qu'une dynamite prête à exploser..."), nl.

description(trou, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 1),
        write("Il n'y a plus rien ici, l'éboulement a détruit tout ce qui se trouvait de l'autre côté du trou."), nl.

description(trou, 0) :-
        write("Vous jetez un oeil dans le trou, vous ne voyez pas grand chose, à part un autre oeil de l'autre côté..."), nl.

description(statuette, 0) :-
        write("C'est une petite figurine poussièreuse en bois. Elle représente un aigle."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Description hub_cauchemar %%%%%%%%%%%%%%%%%%%%%%%%%
description(hub_cauchemar, 1) :-
        visited(Visited),
        list_check_place(hub_cauchemar, galeries, 1, Visited),
        write("Vous regardez autour de vous... Terrifié..."), nl,
        write("Mais il faut continuer d'avancer."), nl, nl,

        write("Le {campement}, les {galeries} ou votre {chambre}, quel sera votre choix ?"), nl.

description(hub_cauchemar, 1) :-
        visited(Visited),
        list_check_place(hub_cauchemar, chansons, 1, Visited),
        write("Vous regardez autour de vous... Terrifié..."), nl,
        write("Mais il faut continuer d'avancer."), nl, nl,

        write("Le {campement}, les {galeries} ou votre {chambre}, quel sera votre choix ?"), nl.
        
description(hub_cauchemar, 1) :-
        nl,
        write("Les [Fragments Étrange] brillent sous vos yeux, se mettent à flotter et se rapproche doucement les uns des autres..."), nl, 
        write("Ils se combinent !"), nl, nl,

        write("        *Vous obtenez 1x [Souvenir]*"), nl, nl,

        write("Un souvenir que vous aviez oublié. Et que vous aurez préféré ne pas vous rappeler."), nl, nl,

        write("De manière presque instantané, la pièce étrange se métamorphose sous vos yeux jusqu'à devenir méconnaissable."),nl,
        write("Les portes vers les {galeries}, le {campement} et même votre {chambre} sont réapparus mais, l'atmosphère vous semble pesante, voir même menacante. Vous avez un très mauvais pressentiment."), nl, nl,

        write("En écoutant aux portes, vous n'entendez rien, impossible de savoir ce qu'il se trouve derrière."), nl, nl,

        write("Cette fois, vous êtes sûr de n'être JAMAIS venu ici."), nl,
        inventory(InventoryList),
        remove_list(["Fragment Étrange", 3], InventoryList, NewList),
        list_add(["Souvenir", 1], NewList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)).

description(campement, 1) :-
        visited(Visited),
        list_check_place(campement, hub_cauchemar, 1, Visited),
        write("La porte est toujours là. Mais... Vous n'avez clairement pas envie d'y retourner, vous êtes traumatisé."), nl.

description(campement, 1) :-
        write("Vous ouvrez la porte correspondant au campement."), nl.

description(chambre, 1) :-
        visited(Visited),
        list_check_place(campement, hub_cauchemar, 1, Visited),
        write("La porte est toujours là. Mais... Vous n'avez clairement pas envie d'y retourner, vous êtes traumatisé."), nl.

description(chambre, 1) :-
        write("Vous ouvrez la porte correspondant à votre chambre."), nl.

description(galeries, 1) :-
        visited(Visited),
        list_check_place(campement, hub_cauchemar, 1, Visited),
        write("La porte est toujours là. Mais... Vous n'avez clairement pas envie d'y retourner, vous êtes traumatisé."), nl.

description(galeries, 1) :-
        write("Vous ouvrez la porte correspondant aux galeries."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Interaction chambre %%%%%%%%%%%%%%%%%%%%%%%%%
interaction(chat, 0) :-
        interactedList(Interacted),
        list_check_place(chat, lit, 0, Interacted),
        %%% CR_F_18
        write("Misty est partie en courant en dehors de la chambre."), nl.

interaction(chat, 0) :-
        %%% CR_O_02
        write("Vous caressez Misty, elle se met à ronronner et se colle à vous. En continuant de la caresser, vous remarquez quelque chose coincé dans ses poils."), nl, nl,

        write("        *Vous obtenez 1x Fragment Étrange*"), nl, nl,

        write("Par malheur, vous lui avez tiré des poils, Misty fait un bond et s'enfuit de la pièce."), nl,
        write("Il faut partir à sa recherche !"), nl,
        inventory(InventoryList),
        list_add(["Fragment Étrange", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(poster, 0) :-
        %%% CR_F_16
        write("Vous vous approchez du poster de 'Inception'."), nl,
        write("Vous vous imaginez que les personnages de l'affiche se mettent à bouger."), nl,
        write("Cela vous remémore de bons souvenirs du film."), nl.

interaction(peluche, 0) :-
        %%% CR_F_04
        write("Vous serrez la peluche fort dans vos bras, qu'importe votre âge, l'enfant en vous est heureux d'avoir fait ça et se sent déterminer à continuer."), nl.


interaction(origami, 0) :-
        interactedList(Interacted),
        list_check_place(origami, etagere, 0, Interacted),
        %%% CR_F_06
        write("Vous admirez ce magnifique origami remis à neuf."), nl.

interaction(origami, 0) :-
        %%% CR_F_20
        write("Vous dépliez le museau du petit renard, l'origami est à nouveau tout neuf."), nl.

interaction(maths, 0) :-
        interactedList(Interacted),
        list_check_place(maths, etagere, 0, Interacted),
        %%% CR_F_21
        write("Non, plus jamais je ne le toucherai !"), nl.

interaction(maths, 0) :-
        %%% CR_F_08
        write("Vous prenez le livre de Mathématiques de votre bibliothèque, et ouvrez au milieu de celui-ci."), nl,
        write("Une vision de nombreux symboles mathématiques vous agresse l'esprit !"), nl,
        write("Par réflexe de survie, vous refermez rapidement ce livre démoniaque et le rangez de nouveau sur l'étagère."), nl,
        write("Vous vous promettez de ne plus jamais y toucher."), nl.

interaction(logique, 0) :-
        %%% CR_F_10
        write("Ce livre édité par Pierre Hyvernat semble divin."), nl,
        write("Celui-ci vous a ouvert les yeux sur les différents aspects de notre monde."), nl,
        write("Désormais, vous arrivez à résonner de façon plus clair et obtiendrez plus de points au partiel de Logique arrivant la semaine prochaine."), nl.

interaction(photo, 0) :-
        %%% CR_F_12
        write("Vous vous remémorez l'ambiance de ce feu de camp. Le parfum des brochettes puis des chamallow pendant que vous vous racontiez diverses histoires, tantôt drôles, tantôt terrifiantes."), nl,
        write("Une envie de refaire ce genre de soirée vous parvient à l'esprit pendant qu'une larme de nostalgie coule sur votre joue."), nl.

interaction(figurine, 0) :-
        %%% CR_F_14
        write("En voyant ce triangle de forme impossible si singulière, vous vous rappelez les plus grandes illusions du musée que vous avez visité."), nl,
        write("Les étoiles plein les yeux, vous décidez de reprendre le parcours de votre chambre."), nl.

interaction(carnet, 0) :-
        interactedList(Interacted),
        list_check_place(carnet, bureau, 0, Interacted),
        %%% CR_F_22
        write("Le carnet est dans votre sac désormais."), nl.

interaction(carnet, 0) :-
        %%% CR_V_01
        write("Vous décidez que ces ustensiles vous seront utiles pour aujourd'hui et les prenez avec vous."), nl, nl,

        write("        *Vous obtenez 1x [Carnet & Stylo]*"), nl, nl,

        write("Une nouvelle commande est apparue. N'hésitez pas à faire 'instructions.' pour la consulter"), nl,
        inventory(InventoryList),
        list_add(["Carnet & Stylo", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).


%%%%%%%%%%%%%%%%%%%%%%%%% Interactions chansons %%%%%%%%%%%%%%%%%%%%%%%%%
interaction(mathieu, 0) :-
        inventory(InventoryList),
        list_check_inventory("Buche", 3, InventoryList),
        list_check_inventory("Fragment Étrange", 1, InventoryList),
        write("'Ah ! Merci pour les buches ! On va pouvoir faire un super feu !'"), nl,
        write("''...'"), nl,
        write("'Ca va ? Tu n'as pas l'air dans ton assiette depuis tout à l'heure...'"), nl,
        write("'Tiens, regarde ce que j'ai trouvé pendant que tu étais parti ! Ca va peut être te remonter le moral, toi qui aime bien les trucs anciens !'"), nl,
        write("Mathieu vous tend un morceau de cristal."), nl, 
        write("'Qu'est-ce que ça peut être à ton avis ?'"), nl, nl,

        write("        *Vous obtenez 1x [Fragment Étrange]*"), nl,

        write("'Alors qu'est-ce que tu en pens-'"), nl,
        write("Vous clignez des yeux, vous êtes de retour dans la pièce étrange."), nl, nl,
        inventory(InventoryList),
        list_add(["Fragment Étrange", 1], InventoryList, NewList),
        remove_list(["Buche", 3], NewList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)),
        retour.

interaction(mathieu, 0) :-
        inventory(InventoryList),
        list_check_inventory("Buche", 3, InventoryList),
        list_check_inventory("Fragment Étrange", 2, InventoryList),
        write("'Ah ! Merci pour les buches ! On va pouvoir faire un super feu !'"), nl,
        write("''...'"), nl,
        write("'Ca va ? Tu n'as pas l'air dans ton assiette depuis tout à l'heure...'"), nl,
        write("'Tiens, regarde ce que j'ai trouvé pendant que tu étais parti ! Ca va peut être te remonter le moral, toi qui aime bien les trucs anciens !'"), nl,
        write("Mathieu vous tend un morceau de cristal."), nl, 
        write("'Qu'est-ce que ça peut être à ton avis ?'"), nl, nl,

        write("        *Vous obtenez 1x [Fragment Étrange]*"), nl,

        write("'Alors qu'est-ce que tu en pens-'"), nl,
        list_add(["Fragment Étrange", 1], InventoryList, NewList),
        remove_list(["Buche", 3], NewList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)),
        retract(cauchemar(_)),
        assert(cauchemar(1)),
        retract(position_courante(_)),
        assert(position_courante(hub_cauchemar)),
        description(hub_cauchemar, 1).

interaction(mathieu, 0) :-
        write("'Oui ? Tu n'as pas encore récupéré les 3 buches ? Il doit y en avoir encore dans la {foret}...'"), nl.

interaction(maxime, 0) :-
        write("'Soon may the Wellerman come !"), nl,
        write("To bring us sugar and tea and rum !"), nl,
        write("One day, when the tonguing is done !"), nl,
        write("We'll take our leave and go...'"), nl.

interaction(feu, 0) :-
        write("'C'est beaucoup trop chaud... Je n'y mettrais pas la main si j'étais toi !' réplique Mathieu."), nl.

interaction(lune, 0) :-
        write("Vous observez le magnifique paysage que vous offre la lune sur ces bois. Cela vous rend, étrangement, nostalgique..."), nl.

interaction(ronces, 0) :-
        cutList(Cut),
        list_check_place(ronces, foret, 0, Cut),
        write("Le passage vers le {Ruisseau} est désormais accessible !"), nl. 

interaction(ronces, 0) :-
        write("'Aie ! Ca pique...', ces ronces n'ont pas l'air très solide pour autant."), nl.

interaction(lianes, 0) :-
        write("Vous décidez de grimper sur la liane la plus rigide et apercevez un [fruit] à portée de main !"), nl.

interaction(fruit, 0) :-
        cutList(Cut),
        list_check_place(fruit, sentier, 0, Cut),
        write("Vous avez déjà coupé le fruit, il n'y a plus rien désormais."), nl. 

interaction(fruit, 0) :-
        write("Vous tentez d'attraper le fruit mais celui-ci semble bien accrocher à l'arbre. Peut être que couper le haut du fruit suffirait à le faire tomber..."), nl.

interaction(arbre, 0) :-
        cutList(Cut),
        list_check_place(arbre, sentier, 0, Cut),
        write("Si vous coupez tout les arbres de ce sentier, vous dénaturerez ce dernier..."), nl. 

interaction(arbre, 0) :-
        write("En tentant d'arracher à main nu cet arbre, vous vous rendez compte que vous n'auriez pas dû arrêter votre abonnement à la salle de musculation si tôt."), nl.

interaction(feuille, 0) :-
        write("Vous prenez un paquet de feuilles et les jetez en avant."), nl,
        write("Ces dernières se prennent dans la brise d'air et virevoltent dans tous les sens."), nl,
        write("Ces nuances de couleurs éclatantes mélangé aux doux rayons de la lune vous offrent un spectacle mémorable."), nl.

interaction(hache, 0) :-
        write("Vous vous emparez de la hache, désormais vous pourrez coupez plus aisément !"), nl, nl,
        write("        *Vous obtenez 1x [Hache]*"), nl,
        inventory(InventoryList),
        list_add(["Hache", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(fleurs, 0) :-
        write("Vous cueillez une des fleurs et sentez son odeur... Un doux parfum vous fait frémir les narines !"), nl.

interaction(branches, 0) :-
        cutList(Cut),
        list_check_place(branches, maison, 0, Cut),
        write("Vous avez déjà coupé la seule branche pouvant faire office de buche."), nl. 

interaction(branches, 0) :-
        write("Vous choisissez la branche la plus épaisse et tentez de la couper à la seule force de vos bras... qui vous font défaut."), nl.

interaction(eau, 0) :-
        write("Vous essayez de traverser le ruisseau mais le courant est si fort que vous avez failli perdre l'équilibre en n'y posant qu'un pied ! Impossible de traverser..."), nl.

interaction(tronc, 0) :-
        cutList(Cut),
        list_check_place(tronc, ruisseau, 0, Cut),
        write("Le tronc d'arbre est tombé au-dessus du ruisseau, vous offrant un pont peu pratique mais fonctionnel."), nl. 

interaction(tronc, 0) :-
        write("En touchant le tronc d'arbre, vous vous rendez compte qu'il n'est pas très stable... En observant de plus prêt, il a été partiellement coupé à sa base ! Quelques coups supplémentaires suffiront peut être..."), nl.

interaction(buche, 0) :-
        inventory(InventoryList),
        list_check_inventory("Buche", 2, InventoryList),
        cutList(Cut),
        list_check_place(tronc, ruisseau, 0, Cut),
        write("Vous récupérez la buche posé à terre. C'était d'une simplicité... déconcertante."), nl, nl,

        write("        *Vous obtenez 1x [Buche]*"), nl, nl,

        write("Vous constatez par malheur que vous avez perdu votre hache à ce moment-là..."), nl,
        inventory(InventoryList),
        list_add(["Buche", 1], InventoryList, NewList),
        remove_list(["Hache", 1], NewList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)).

interaction(buche, 0) :-
        cutList(Cut),
        list_check_place(tronc, ruisseau, 0, Cut),
        write("Vous récupérez la buche posé à terre. C'était d'une simplicité... déconcertante."), nl, nl,

        write("        *Vous obtenez 1x [Buche]*"), nl,
        inventory(InventoryList),
        list_add(["Buche", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(buche, 0) :-
        write("Il faut trouver un moyen de franchir le ruisseau pour faire cela."), nl.

interaction(animal, 0) :-
        cutList(Cut),
        \+ list_check_place(tronc, ruisseau, 0, Cut),
        write("Il faut trouver un moyen de franchir le ruisseau pour faire cela."), nl.

interaction(animal, 0) :-
        actions(Actions),
        check_if_positif(Actions, 0),
        write("Le petit lapin s'est enfui après que vous l'ayez nourri."), nl.

interaction(animal, 0) :-
        inventory(InventoryList),
        list_check_inventory("Fruit", InventoryList),
        write("Vous tendez le fruit à l'animal... Il est craintif..."), nl,
        write("Vous posez le fruit à vos pieds puis reculez suffisamment."), nl,
        write("L'animal s'approche lentement... Et déguste le fruit devant vous !"), nl, nl,    

        write("        *Vous notez cette expérience unique dans votre carnet*"), nl,
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
        write("Le corps sans vie de la bête git au sol."), nl.

interaction(animal, 0) :-
        write("Si vous vous approchez trop prêt de l'animal, il pourrait s'enfuir, mieux vaut éviter et trouver quelque chose pour l'appâter..."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Interaction galeries %%%%%%%%%%%%%%%%%%%%%%%%%
interaction(pelle, 0) :-
        write("Vous saisissez de vos mains cette magnifique pelle. Celle-ci est votre désormais. Prêt à obéir à chacun de vos ordres, vous pouvez désormais (Creuser) certains murs ou minerais par exemple."), nl, nl,

        write("        *Vous obtenez 1x [Pelle]*"), nl, nl,

        write("Une nouvelle commande est apparue. N'hésitez pas à faire 'instructions.' pour la consulter"), nl,
        inventory(InventoryList),
        list_add(["Pelle", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(gerald, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 1),
        inventory(InventoryList),
        list_check_inventory("Fragment Étrange", 1, InventoryList),
        geraldMauvais,
        retour.    

interaction(gerald, 0) :-
        actions(Actions),
        check_if_positif(Actions, 1),
        inventory(InventoryList),
        list_check_inventory("Fragment Étrange", 1, InventoryList),
        geraldBon,
        retour.      

interaction(gerald, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 1),
        inventory(InventoryList),
        list_check_inventory("Fragment Étrange", 2, InventoryList),
        geraldMauvais,
        retract(cauchemar(_)),
        assert(cauchemar(1)),
        retract(position_courante(_)),
        assert(position_courante(hub_cauchemar)),
        description(hub_cauchemar, 1).
                
interaction(gerald, 0) :-
        actions(Actions),
        check_if_positif(Actions, 1),
        inventory(InventoryList),
        list_check_inventory("Fragment Étrange", 2, InventoryList),
        geraldBon,
        retract(cauchemar(_)),
        assert(cauchemar(1)),
        retract(position_courante(_)),
        assert(position_courante(hub_cauchemar)),
        description(hub_cauchemar, 1).        

interaction(gerald, 0) :-
        write("'Aaaaah ! Te voilà enfin ! On a besoin de toi pour continuer à explorer nos galeries... On n'a plus de nouvelle de Richard depuis quelques minutes, ça nous inquiète pas mal, tu pourrais nous aider à le chercher ? Et si tu peux récupérer quelques pierres précieuses en même temps, profites-en !'"), nl.

interaction(minerais, 0) :-
        write("Vous touchez quelques-uns de ces minerais, ils sont froids et raffraichissant, cela contraste bien avec la chaleur que vous ressentez sous toutes ces couches de vêtements... Vous continuez à toucher des minerais jusqu'à vous en lasser et continuer votre exploration."), nl.

interaction(friable, 0) :-
        write("Vous posez votre pelle par terre et tentez de griffer le mur avec vos mains, après tout, qui a besoin d'outil quand notre corps est si pratique ?"), nl.

interaction(toile, 0) :-
        write("Vous balayez l'une des toiles d'araignée à coup de pelle ! Il en reste encore... vraiment beaucoup. Mieux vaut arrêter d'essayer de faire du ménage dans ces galeries."), nl.

interaction(joyaux, 0) :-
        write("Dur comme de la roche, cette pierre ne se cassera qu'à l'aide de votre pelle pour sûr ! Vous pouvez néanmoins tester avec vos mains... Vous y arriverez un jour pour sûr !"), nl.

interaction(pioche, 0) :-
        write("Vous récupérez la pioche, vous pouvez désormais détruire un plus gros mur ! Sur son dos il y est écrit 'Made In China, Usage Unique'..."), nl, nl,
        
        write("        *Vous obtenez 1x [Pioche]*"), nl,
        inventory(InventoryList),
        list_add(["Pioche", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(dynamite, 0) :-
        interactedList(Interacted),
        list_check_place(dynamite, escalier, 0, Interacted),
        write("La dynamite a explosé, ne laissant qu'un [trou] béant derrière son passage"), nl.

interaction(dynamite, 0) :-
        write("Vous allumez la dynamite et courez le plus loin possible !"), nl,
        write("BOOOOM !"), nl,
        write("En revenant sur les lieux, vous découvrez un [trou] à l'endroit où la dynamite a explosé."), nl.

interaction(trou, 0) :-
        interactedList(Interacted),
        list_check_place(dynamite, escalier, 0, Interacted),
        write("Un trou ? Quel trou ? Je ne vois qu'une dynamite prête à exploser..."), nl.

interaction(trou, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 1),
        write("Il n'y a plus rien ici, l'éboulement a détruit tout ce qui se trouvait de l'autre côté du trou."), nl.

interaction(trou, 0) :-
        write("'Hey ! C'est Richard ! Je suis coincé ici ! Tu peux m'aider ? Il faudrait que tu ailles récupérer la [pioche] qui se trouve au passage, c'est la pièce au-dessus de moi ! Reviens avec et tu pourras creuser ce trou dans le mur pour me libérer !'"), nl.

interaction(statuette, 0) :-
        write("L'heure n'est pas à la récolte, vous vous jouerez de récupérer cette figurine avant de partir pour garder un souvenir de cette expédition."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Couper chansons %%%%%%%%%%%%%%%%%%%%%%%%%

couperTexte(ronces, 0) :-
        cutList(Cut),
        list_check_place(ronces, foret, 0, Cut),
        write("Le passage vers le {ruisseau} est désormais accessible !"), nl. 

couperTexte(ronces, 0) :-
        write("Vous assénez de grands coups de couteau dans ces pauvres ronces et dégagez le passage vers le {ruisseau} !"), nl.

couperTexte(fruit, 0) :-
        cutList(Cut),
        list_check_place(fruit, sentier, 0, Cut),
        write("Vous avez déjà coupé le fruit, il n'y a plus rien désormais."), nl. 

couperTexte(fruit, 0) :-
        write("Vous coupez le haut du fruit, ce dernier tombe par terre. Vous le récupérez, il vous servira peut être plus tard !"), nl, nl,

        write("        *Vous obtenez 1x [Fruit]*"), nl,
        inventory(InventoryList),
        list_add(["Fruit", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

couperTexte(arbre, 0) :-
        cutList(Cut),
        list_check_place(arbre, sentier, 0, Cut),
        write("Si vous coupez tout les arbres de ce sentier, vous dénaturerez ce dernier..."), nl. 

couperTexte(arbre, 0) :-
        inventory(InventoryList),
        list_check_inventory("Buche", 2, InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Vous assénez de grand coup de hache dans le tronc de l'arbre et arrivez aisément à le faire faillir."), nl, nl,

        write("        *Vous obtenez 1x [Buche]*"), nl, nl,

        write("Votre hache s'est malheuresement cassée sur le coup..."), nl,
        list_add(["Buche", 1], InventoryList, NewList),
        remove_list(["Hache", 1], NewList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)).

couperTexte(arbre, 0) :-
        inventory(InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Vous assénez de grand coup de hache dans le tronc de l'arbre et arrivez aisément à le faire faillir."), nl, nl,

        write("        *Vous obtenez 1x [Buche]*"), nl,
        list_add(["Buche", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

couperTexte(arbre, 0) :-
        write("Malgré vos efforts, vous vous rendez à l'évidence : Votre faible couteau ne vous permettra pas de couper cet énorme tronc d'arbre."), nl.

couperTexte(branches, 0) :-
        cutList(Cut),
        list_check_place(branches, maison, 0, Cut),
        write("Vous avez déjà coupé la seule branche pouvant faire office de buche."), nl. 

couperTexte(branches, 0) :-
        inventory(InventoryList),
        list_check_inventory("Buche", 2, InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Avec votre superbe hache, vous DÉTRUISEZ la base d'une des branches et la récupérez !"), nl, nl,

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
        write("Avec votre superbe hache, vous DÉTRUISEZ la base d'une des branches et la récupérez !"), nl, nl,

        write("        *Vous obtenez 1x [Buche]*"), nl,
        inventory(InventoryList),
        list_add(["Buche", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

couperTexte(branches, 0) :-
        write("Votre couteau ne semble pas affecter ne serait-ce que l'écorce de la branche, il vous faudrait quelque chose de plus tranchant."), nl.

couperTexte(tronc, 0) :-
        cutList(Cut),
        list_check_place(tronc, ruisseau, 0, Cut),
        write("Le tronc d'arbre est tombé au-dessus du ruisseau, vous offrant un pont peu pratique mais fonctionnel."), nl. 

couperTexte(tronc, 0) :-
        inventory(InventoryList),
        list_check_inventory("Hache", InventoryList),
        write("Vous frappez à de nombreuses reprises le tronc... Il tremble... Puis se met à tomber !"), nl,
        write("Vous pouvez désormais accéder à l'autre côté du ruisseau, là où se trouve une [buche] et un petit [animal] !"), nl.

couperTexte(tronc, 0) :-
        write("Vous essayez de couper le tronc avec votre couteau, mais, il s'avère inefficace..."), nl.

couperTexte(animal, 0) :-
        cutList(Cut),
        \+ list_check_place(tronc, ruisseau, 0, Cut),
        write("Il faut trouver un moyen de franchir le ruisseau pour faire cela."), nl.

couperTexte(animal, 0) :-
        cutList(Cut),
        list_check_place(animal, ruisseau, 0, Cut),
        write("Le corps sans vie de la bête git au sol."), nl.

couperTexte(animal, 0) :-
        write("Vous vous lancez brutalement sur l'animal et lui assénez plusieurs coups de couteaux, la bête hurle de douleur et agonise lentement au sol. Son sang coule dans le ruisseau."), nl, nl,

        write("        *Vous notez cette expérience unique dans votre carnet*"), nl,
        actions(Actions),
        change_list(0, -1, Actions, NewList),
        retract(actions(_)),
        assert(actions(NewList)).


%%%%%%%%%%%%%%%%%%%%%%%%% Creuser galeries %%%%%%%%%%%%%%%%%%%%%%%%%
creuserTexte(friable, 0) :-
        write("Vous creusez au niveau du mur qui vous semblait friable... et vous aviez vu juste ! Un nouvel {escalier} se révèle sous vos yeux !"), nl.

creuserTexte(joyaux, 0) :-
        creusageList(Creusage),
        list_check_place(trou, escalier, 0, Creusage),
        write("Vous avez pris toutes les précautions nécessaires, et ayant sauvé Richard, vous pouvez facilement récupérer les joyaux présents sur la pierre. Ce que vous vous empressez de faire afin de vous en mettre plein les poches évidemment."), nl, nl,

        write("        *Faites un rapport de la situation à [Gérald] !*"), nl.

creuserTexte(joyaux, 0) :-
        write("Dans l'empressement de votre découverte, vous sautez sur la pierre aux joyaux. Asséner votre premier coup de pelle et le sol se dérobe sous vos pieds !"), nl,
        write("L'éboulement à totalement détruit la pièce du dessous..."), nl, nl,

        write("        *Vous notez cette expérience unique dans votre carnet*"), nl, nl,

        write("*Faites un rapport de la situation à [Gérald] !*"), nl,
        actions(Actions),
        change_list(1, -1, Actions, NewList),
        retract(actions(_)),
        assert(actions(NewList)).

creuserTexte(trou, 0) :-
        actions(Actions),
        check_if_negatif(Actions, 1),
        write("Il n'y a plus rien ici, l'éboulement a détruit tout ce qui se trouvait de l'autre côté du trou."), nl.

creuserTexte(trou, 0) :-
        interactedList(Interacted),
        list_check_place(dynamite, escalier, 0, Interacted),
        inventory(InventoryList),
        list_check_inventory("Pioche", InventoryList),
        write("Grâce à votre nouvelle pioche, vous arrivez assez aisément à ouvrir un passage pour laisser Richard sortir ! Votre mission est réussie ! Vous pouvez encore vous balader dans les galeries ou faire tout de suite votre rapport à [Gérald]."), nl, nl,

        write("        *Vous notez cette expérience unique dans votre carnet*"), nl, nl,

        write("Votre pioche se casse bien sur le coup... Les produits fait en Chine ne sont pas très solides..."), nl,
        actions(Actions),
        change_list(1, 1, Actions, NewList),
        retract(actions(_)),
        assert(actions(NewList)),
        remove_list(["Pioche", 1], InventoryList, NewList2),
        retract(inventory(_)),
        assert(inventory(NewList2)).
        
creuserTexte(trou, 0) :-
        interactedList(Interacted),
        list_check_place(dynamite, escalier, 0, Interacted),
        write("Vous tentez de creuser avec votre pelle... Cela ne semble pas efficace, le mur est trop solide !"), nl.

creuserTexte(trou, 0) :-
        write("Un trou ? Quel trou ? Je ne vois aucun trou ici..."), nl.


%%%%%%%%%%%%%%%%%%%%%%%%% Pages carnet %%%%%%%%%%%%%%%%%%%%%%%%%
lire(1) :-
        actions(Actions),
        check_if_positif(Actions, 0),
        write("Souvenir positif de la salle du feu de camp."), nl, nl,

        write("J'ai posé un fruit devant un animal roux de l'autre côté d'un ruisseau."), nl,
        write("Celui-ci l'a dégusté devant moi... Trop mignon !"), nl, nl,

        write("Page suivante avec 'suiv.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(1)),
        !.

lire(1) :-
        actions(Actions),
        check_if_negatif(Actions, 0),
        write("Souvenir négatif de la salle du feu de camp."), nl, nl,
        
        write("En lançant un couteau sur un animal et en lui assenant plusieurs coups de couteaux, celui-ci s'est roulé de douleur avant d'agoniser sur le sol..."), nl,
        write("Était-ce vraiment une expérience sympathique ?"), nl, nl,

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

        write("Ayant pris toutes les précautions nécessaires, et ayant sauvé Richard, j'ai pu facilement récupérer les joyaux présents sur la pierre."), nl,
        write("Je repars les poches pleines de joyaux !"), nl, nl,

        write("Page suivante avec 'suiv.'"), nl,
        write("Page précédente avec 'prev.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(2)),
        !.

lire(2) :-
        actions(Actions),
        check_if_negatif(Actions, 0),
        write("Souvenir négatif de la salle des galeries."), nl, nl,

        write("Dans l'empressement de la découverte de joyaux, le sol s'est dérobé sous mes pieds au premier coup de pelle..."), nl,
        write("L'éboulement à totalement détruit la pièce du dessous..."), nl, nl,

        write("Page suivante avec 'suiv.'"), nl,
        write("Page précédente avec 'prev.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(2)),
        !.

lire(2) :-
        write("Cette page est vide."), nl, nl,

        write("Page suivante avec 'suiv.'"), nl,
        write("Page précédente avec 'prev.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(2)),
        !.

lire(3) :-
        write("Cette page est vide."), nl, nl,

        write("Page suivante avec 'suiv.'"), nl,
        write("Page précédente avec 'prev.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(3)),
        !.



%%%%%%%%%%%%%%%%%%%%%%%%% Fonction pour pas répéter les textes 40 fois %%%%%%%%%%%%%%%%%%%%%%%%%

geraldBon :-
        write("        *Vous expliquez à Gérald ce qu'il s'est passé*"), nl, nl,

        write("'Ahahah ! C'est passé de peu, hein Richard ?!'"), nl,
        write("'C'est sûr, si le petit gars n'avait pas été là, j'aurais pas donner chère de ma peau !' répliqua-t-il."), nl, 
        write("'Je te dois une belle chandelle bonhomme ! Tiens, c'est peu par rapport au prix de ma vie, mais j'avais trouvé ça durant mes fouilles'"), nl, 
        write("Richard vous tend un mystérieux objet..."), nl, nl,

        write("        *Vous avez obtenu 1x [Fragment Étrange]*"), nl, nl,

        write("'Bon, c'est pas tout ça, on va manger ? Ces mésaventures m'ont ouvert l'a-'"), nl,
        inventory(InventoryList),
        list_add(["Fragment Étrange", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

geraldMauvais :-
        write("        *Vous expliquez à Gérald ce qu'il s'est passé*"), nl, nl,

        write("'Je vois, ce n'est pas ta faute, tu ne pouvais pas savoir ce qui allait se passer..."), nl,
        write("Ecoute, mes gars et moi, on va dégager tout ce foutoir et on revient vers toi après..."), nl, 
        write("J'ai besoin d'être un peu seul.'"), nl, nl,

        write("        ** Quelques heures plus tard **"), nl, nl,

        write("'Bon, malheureusement, on a bien retrouvé Richard sous les décombres..."), nl,
        write("On a également trouvé ça, on ne sait pas ce que c'est, ça te dit quelque chose ?'"), nl,
        write("Gérald vous tend un mystérieux objet... A peine vous le touchez que... vous êtes de retour dans la salle étrange."), nl, nl,

        write("        *Vous avez obtenu 1x [Fragment Etrange]*"), nl,
        inventory(InventoryList),
        list_add(["Fragment Étrange", 1], InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).
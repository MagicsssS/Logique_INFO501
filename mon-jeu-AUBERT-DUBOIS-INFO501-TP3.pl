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

:- dynamic visited/1.
visited([]).

:- dynamic dernierePage/1.
dernierePage(_).

:- dynamic actions/1.
actions([_,_,_,_,_,_,_,_]).

% passages entre les différents endroits du jeu
passage(chambre, lit, lit).
passage(chambre, etagere, etagere). 
passage(chambre, bureau, bureau).
passage(chambre, porte, hub).

% RETOURS
retour(lit, chambre). 
retour(etagere, chambre). 
retour(bureau, chambre). 


% position des objets
position(chat, lit).
position(poster, lit).
position(peluche, lit).
position(origami, etagere).
position(maths, etagere).
position(logique, etagere). 
position(photo, bureau). 
position(figurine, bureau). 
position(carnet, bureau). 


% Rule to prepend an element in a list.
list_add(Name, OldList, NewList):-
	NewList = [Name|OldList].

% Rule to check if an item exists in a list.
list_check(Name, [Name|_]).
list_check(Name, [_|T]):- list_check(Name, T).

% observer quelque chose
observer(X) :-
        position_courante(P),
        position(X, P),
        description(X),
        !.

observer(X) :-
        write("Je ne vois pas de "),
        write(X),
        write(" ici. Allez-vous vraiment bien ?"), nl,
        fail.


% interagir avec quelque chose
interagir(X) :-
        position_courante(P),
        position(X, P),
        interaction(X), nl,
        interactedList(Interacted),
        list_add(X, Interacted, NewList),
        retract(interactedList(_)),
        assert(interactedList(NewList)),
        !.

interagir(X) :-
        write("Je ne vois pas de "),
        write(X),
        write(" ici. Allez-vous vraiment bien ?"), nl,
        fail.

regarder :-
        position_courante(Ici),
        description(Ici), 
        !.


% analyser votre inventaire.
print_inventory([H|[]]):- write('    '), write(H), nl, !.
print_inventory([H|T]):-
	write('    '), write(H), nl,
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
b :- retour.
r :- regarder.

:- op(1000, fx, o).
:- op(1000, fx, int).
:- op(1000, fx, inv).
:- op(1000, fx, c).
:- op(1000, fx, go).

% on déclare des opérateurs, pour autoriser `prendre torche` au lieu de `prendre(torche)`
:- op(1000, fx, observer).
:- op(1000, fx, interagir).
:- op(1000, fx, aller).
:- op(1000, fx, carnet).


% déplacements
aller(porte) :-
        inventory(Inventory),
        \+ list_check("Carnet & Stylo", Inventory),
        %%% CR_F_23
        write("Change ce texte"), nl, nl,
        position_courante(Ici),
        description(Ici), 
        !.

aller(porte) :-
        interactedList(Interacted),
        \+ list_check(chat, Interacted),
        %%% CR_F_17
        write("Vous mettez la main sur la poignée, votre chat miaule et demande une caresse, mieux vaut lui dire au revoir avant de partir."), nl, nl,
        position_courante(Ici),
        description(Ici), 
        !.

aller(Direction) :-
        position_courante(Ici),
        passage(Ici, Direction, La),
        description(Direction),
        retract(position_courante(Ici)),
        assert(position_courante(La)),
        visited(Visited),
        list_add(Ici, Visited, NewList),
        retract(visited(_)),
        assert(visited(NewList)),
        !.

aller(_) :-
        write("Où essayez vous d'aller ? Cet endroit n'existe pas."), nl,
        fail.


retour :-
        position_courante(Ici),
        retour(Ici, Avant),
        description(Avant),
        retract(position_courante(Ici)),
        assert(position_courante(Avant)),
        !.

retour :-
        write("Où voulez-vous retourner ? Vous êtes déjà au centre de cet endroit."), nl,
        fail.

carnet(X) :-
        lire(X).

increase(X, X1) :-
        X1 is X+1.

decrease(X, X1) :-
        X1 is X-1.

equal(X,Y) :-
        X == Y.

suiv :-
        dernierePage(Last),
        increase(Last, New),
        \+ equal(New, 9),
        retract(dernierePage(Last)),
        assert(dernierePage(New)),
        lire(New).

suiv :-
        write("Vous êtes déjà à la fin du carnet !"), nl.

prev :-
        dernierePage(Last),
        decrease(Last, New),
        \+ equal(New, 0),
        retract(dernierePage(Last)),
        assert(dernierePage(New)),
        lire(New).

prev :-
        write("Vous êtes déjà au début du carnet !"), nl.

check_if_positif(Liste, Num) :-
        nth0(Num, Liste, Element),
        Element > 0.

check_if_negatif(Liste, Num) :-
        nth0(Num, Liste, Element),
        Element < 0.

change_list(Index, NewVal, List, NewList) :-
        nth0(Index, List, _, TempList),
        nth0(Index, NewList, NewVal, TempList).


% fin de partie
fin :-
        nl, write("La partie est finie."), nl,
        halt.


% affiche les instructions du jeu
instructionsall :-
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

instructionfin :-
        write("instructions.                      -- pour revoir ce message !"), nl,
        write("fin.                               -- pour terminer la partie et quitter."), nl.

instructions :-
        inventory(Inventory),
        list_check("Carnet & Stylo", Inventory),
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
        instructions,
        position_courante(Ici),
        description(Ici),
        visited(Visited),
        list_add(Ici, Visited, NewList),
        retract(visited(_)),
        assert(visited(NewList)).


%%%%%%%%%%%%%%%%%%%%%%%%% Emplacements chambre %%%%%%%%%%%%%%%%%%%%%%%%%
description(chambre) :- 
        visited(Visited),
        list_check(chambre, Visited),
        write("Vous êtes toujours dans votre chambre. Vous y apercevez votre {lit}, qui semble très moelleux..."), nl,
        write("Quelques livres sont posés sur votre {etagere}, n'attendant que vous pour les prendre et vous asseoir en face de votre {bureau} les lire."), nl,
        write("Le soleil levant éclaire légèrement la {porte} de votre chambre.").

description(chambre) :- 
        %%% CR_D0
        write("Le soleil se lève, amenant une douce éclaircie sur la {porte} de votre chambre."), nl, 
        write("Vous avez fait votre {lit}, celui-ci semble désormais si moelleux..."), nl,
        write("Mais, quelques livres sont posés sur votre {etagere}, n'attendant que vous pour les prendre et vous asseoir en face de votre {bureau} les lire."), nl, nl,
        write("Où voulez-vous ALLER ?"), nl.

description(lit) :-
        %%% CR_D1 
        write("Vous vous approchez du lit. Celui-ci semble moelleux et accueillant."), nl, 
        write("Misty, votre [chat], vous regarde avec des yeux ronds, semblant attendre quelque chose de vous."), nl, 
        write("Un [poster] est accroché sur le mur, au-dessus du lit."), nl, 
        write("Une petite [peluche] est posée à côté de votre oreiller."), nl.

description(etagere) :-
        %%% CR_D2
        write("Vous vous approchez de l'étagère. Sur celle-ci il y a deux livres, un de [Maths] et un de [Logique]."), nl, 
        write("Un [origami] fait-main est également posé sur cette étagère."), nl.

description(bureau) :-
        %%% CR_D3
        write("Vous vous approchez du bureau. Un [carnet] est mis en évidence au milieu de celui-ci. Une [photo] encadrée est soutenu par un [triangle] peu commun."), nl.

description(porte) :-
        interactedList(Interacted),
        list_check(chat, Interacted),
        inventory(Inventory),
        list_check("Carnet & Stylo", Inventory),
        %%% CR_OV
        write("Vous ouvrez la porte, et sortez de votre chambre."), nl.

% ?
description(hub) :-
        write("Change ce texte").


%%%%%%%%%%%%%%%%%%%%%%%%% Objets chambre %%%%%%%%%%%%%%%%%%%%%%%%%

description(chat) :-
        interactedList(Interacted),
        list_check(chat, Interacted),
        %%% CR_F_18
        write("Misty est partie en courant en dehors de la chambre."), nl.

description(chat) :-
        %%% CR_F_01
        write("Misty, votre petit chat noir, se dresse sur le lit en vous observant. Elle miaule dans votre direction."), nl.

description(poster) :-
        %%% CR_F_02
        write("C'est un poster du film 'Inception'. On y voit 6 personnages dans une ville distordue par la réalité des rêves."), nl.

description(peluche) :-
        %%% CR_F_03
        write("Une peluche en forme de T-Rex que vous avez obtenu plus jeune, en allant à la fête foraine avec votre famille."), nl.

description(origami) :-
        interactedList(Interacted),
        list_check(origami, Interacted),
        %%% CR_F_05
        write("Un origami en forme de renard que vous avez réalisé durant une conférence sur les origamis."), nl, 
        write("Vous êtes fier de l'avoir remis à neuf."), nl.

description(origami) :-
        %%% CR_F_19
        write("Un origami en forme de renard que vous avez réalisé durant une conférence sur les origamis."), nl, 
        write("Celui-ci semble être courbé au niveau du museau."), nl.

description(maths) :-
        %%% CR_F_07
        write("Le livre de Maths a pour titre 'Maths, Application et Algèbre'."), nl,
        write("La poussière l'envahit, il ne semble pas avoir été ouvert depuis longtemps."), nl.

description(logique) :-
        %%% CR_F_09
        write("Le livre de Logique a pour titre 'Logique, Illogique, et Démontrer par l'Absurdité'."), nl,
        write("Contrairement à son confrère, ce livre semble avoir été acheté récemment, il est en parfait état."), nl.

description(photo) :-
        %%% CR_F_11
        write("Un selfie de vous et vos amis, autour d'un superbe feu de camp dans la forêt."), nl,
        write("La photo a été mise dans un très joli cadre afin de ne pas abimer ce précieux souvenir."), nl.

description(figurine) :-
        %%% CR_F_13
        write("Ce triangle est une représentation du triangle impossible en version miniaturisé. Vous l'avez obtenu durant une visite au musée des illusions."), nl.

description(carnet) :-
        interactedList(Interacted),
        list_check(carnet, Interacted),
        %%% CR_F_22
        write("Le carnet est dans votre sac désormais."), nl.

description(carnet) :-
        %%% CR_F_15
        write("Un simple carnet que vous venez d'acheter, est posé sur le bureau, sur sa couverture se trouve un stylo qui vous a suivi toute votre vie puisqu'il ne vous a jamais failli depuis le début de vos études. En même temps vous ne l'avez pas beaucoup utilisé."), nl.


interaction(chat) :-
        interactedList(Interacted),
        list_check(chat, Interacted),
        %%% CR_F_18
        write("Misty est partie en courant en dehors de la chambre."), nl.

interaction(chat) :-
        %%% CR_O_02
        write("Vous caressez Misty, elle se met à ronronner et se colle à vous. En continuant de la caresser, vous remarquez quelque chose coincé dans ses poils."), nl, nl,
        write("        *Vous obtenez 1x Fragment de Clé*"), nl, nl,
        write("Par malheur, vous lui avez tiré des poils, Misty fait un bond et s'enfuit de la pièce."), nl,
        write("Il faut partir à sa recherche !"), nl,
        inventory(InventoryList),
        list_add("Fragment de clé", InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).

interaction(poster) :-
        %%% CR_F_16
        write("Change ce texte"), nl.

interaction(peluche) :-
        %%% CR_F_04
        write("Vous serrez la peluche fort dans vos bras, qu'importe votre âge, l'enfant en vous est heureux d'avoir fait ça et se sent déterminer à continuer."), nl.


interaction(origami) :-
        interactedList(Interacted),
        list_check(origami, Interacted),
        %%% CR_F_20
        write("Vous dépliez le museau du petit renard, l'origami est à nouveau tout neuf."), nl.

interaction(origami) :-
        %%% CR_F_06
        write("Vous avez déjà remis l'origami est à neuf."), nl.

interaction(maths) :-
        interactedList(Interacted),
        list_check(maths, Interacted),
        %%% CR_F_21
        write("Non, plus jamais je ne le toucherai !"), nl.

interaction(maths) :-
        %%% CR_F_08
        write("Vous prenez le livre de Mathématiques de votre bibliothèque, et ouvrez au milieu de celui-ci."), nl,
        write("Une vision de nombreux symboles mathématiques vous agresse l'esprit !"), nl,
        write("Par réflexe de survie, vous refermez rapidement ce livre démoniaque et le rangez de nouveau sur l'étagère."), nl,
        write("Vous vous promettez de ne plus jamais y toucher."), nl.

interaction(logique) :-
        %%% CR_F_10
        write("Ce livre édité par Pierre Hyvernat semble divin."), nl,
        write("Celui-ci vous a ouvert les yeux sur les différents aspects de notre monde."), nl,
        write("Désormais, vous arrivez à résonner de façon plus clair et obtiendrez plus de points au partiel de Logique arrivant la semaine prochaine."), nl.

interaction(photo) :-
        %%% CR_F_12
        write("Vous vous remémorez l'ambiance de ce feu de camp. Le parfum des brochettes puis des chamallow pendant que vous vous racontiez diverses histoires, tantôt drôles, tantôt terrifiantes."), nl,
        write("Une envie de refaire ce genre de soirée vous parvient à l'esprit pendant qu'une larme de nostalgie coule sur votre joue."), nl.

interaction(figurine) :-
        %%% CR_F_14
        write("En voyant ce triangle de forme impossible si singulière, vous vous rappelez les plus grandes illusions du musée que vous avez visité."), nl,
        write("Les étoiles plein les yeux, vous décidez de reprendre le parcours de votre chambre."), nl.

interaction(carnet) :-
        interactedList(Interacted),
        list_check(carnet, Interacted),
        %%% CR_F_22
        write("Le carnet est dans votre sac désormais."), nl.

interaction(carnet) :-
        %%% CR_V_01
        write("Vous décidez que ces ustensiles vous seront utiles pour aujourd'hui et les prenez avec vous."), nl, nl,
        write("        *Vous obtenez 1x [Carnet & Stylo]*"), nl, nl,
        write("Une nouvelle commande est apparue. N'hésitez pas à faire 'instructions.' pour la consulter"), nl,
        inventory(InventoryList),
        list_add("Carnet & Stylo", InventoryList, NewList),
        retract(inventory(_)),
        assert(inventory(NewList)).


%%%%%%%%%%%%%%%%%%%%%%%%% Pages carnet %%%%%%%%%%%%%%%%%%%%%%%%%

lire(1) :-
        actions(Actions),
        check_if_positif(Actions, 0),
        write("Oui ici c'est positif"), nl, nl,
        write("Page suivante avec 'suiv.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(1)).

lire(1) :-
        actions(Actions),
        check_if_negatif(Actions, 0),
        write("Non ici c'est négatif"), nl, nl,
        write("Page suivante avec 'suiv.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(1)).

lire(1) :-
        write("Cette page est vide."), nl,
        write("Page suivante avec 'suiv.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(1)).

lire(2) :-
        write("Eheh c'est la deuxième page du carnet"), nl, nl,
        write("Page suivante avec 'suiv.'"), nl,
        write("Page précédente avec 'prev.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(2)).

lire(3) :-
        write("Eheh c'est la troisième page du carnet"), nl, nl,
        write("Page suivante avec 'suiv.'"), nl,
        write("Page précédente avec 'prev.'"), nl,
        dernierePage(Last),
        retract(dernierePage(Last)),
        assert(dernierePage(3)).
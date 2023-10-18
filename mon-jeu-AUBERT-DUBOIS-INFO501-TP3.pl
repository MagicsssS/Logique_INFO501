%%% INFO-501, TP3
%%% Pierre Hyvernat
%%%
%%% Lancez la "requête"
%%% jouer.
%%% pour commencer une partie !
%

% il faut déclarer les prédicats "dynamiques" qui vont être modifiés par le programme.
:- dynamic position/2, position_courante/1, position_precedente/1.

% on remet à jours les positions des objets et du joueur
:- retractall(position(_, _)), retractall(position_courante(_)).

% on déclare des opérateurs, pour autoriser `prendre torche` au lieu de `prendre(torche)`
:- op(1000, fx, observer).
:- op(1000, fx, interagir).
:- op(1000, fx, aller).


% position du joueur. Ce prédicat sera modifié au fur et à mesure de la partie (avec `retract` et `assert`)
position_courante(chambre).
position_precedente(chambre).

:- dynamic inventory/1.
inventory([]).

:- dynamic interactedList/1.
interactedList([]).

% passages entre les différents endroits du jeu
passage(chambre, porte, hub). 
passage(chambre, lit, lit).
passage(chambre, etagere, etagere). 
passage(chambre, bureau, bureau). 

passage(lit, chambre, chambre). 
passage(etagere, chambre, chambre). 
passage(bureau, chambre, chambre). 


% position des objets
position(chat, lit).
position(poster, lit).
position(peluche, lit).
position(origami, etagere).
position(maths, etagere).
position(logique, etagere). 
position(photo, bureau). 
position(triangle, bureau). 
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
        interaction(X),
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

print_inventory([H|[]]):- write('    '), write(H), nl, !.
print_inventory([H|T]):-
	write('    '), write(H), nl,
	print_inventory(T).

% analyser votre inventaire.
inventaire:-
	inventory(InventoryList),
	nl, write("Vous possédez : "), nl,
	print_inventory(InventoryList), nl.


% quelques raccourcis
n :- aller(nord).
s :- aller(sud).
e :- aller(est).
o :- aller(ouest).


% déplacements
aller(Direction) :-
        position_courante(Ici),
        position_precedente(Avant),
        passage(Ici, Direction, La),
        retract(position_precedente(Avant)),
        assert(position_precedente(Ici)),
        retract(position_courante(Ici)),
        assert(position_courante(La)),
        analyseSalle, !.

aller(_) :-
        write("Où essayez vous d'aller ? Cet endroit n'existe pas."), nl,
        fail.

retour :-
        position_courante(Ici),
        position_precedente(Avant),
        passage(Ici, Avant, La),
        retract(position_courante(Ici)),
        assert(position_courante(La)),
        analyseSalle, !.

retour :-
        write("Où voulez-vous retourner ? Vous êtes déjà au centre de la pièce"), nl,
        fail.


% regarder autour de soi
analyseSalle :-
        position_courante(Place),
        description(Place), nl.


% fin de partie
fin :-
        nl, write("La partie est finie."), nl,
        halt.


% affiche les instructions du jeu
instructions :-
        nl,
        write("Les commandes doivent être données avec la syntaxe Prolog habituelle."), nl,
        write("Les commandes existantes sont :"), nl, nl,
        write("jouer.                   -- pour commencer une partie."), nl,
        write("aller(direction)         -- pour aller dans cette direction."), nl,
        write("retour.                  -- pour retourner au centre de la pièce."), nl,
        write("observer.                -- pour regarder quelque chose."), nl,
        write("interagir.               -- pour interagir avec quelque chose."), nl,
        write("inventaire.              -- pour analyser votre inventaire"), nl,
        write("instructions.            -- pour revoir ce message !"), nl,
        write("fin.                     -- pour terminer la partie et quitter."), nl,
        nl.



% lancer une nouvelle partie
jouer :-
        instructions,
        analyseSalle.


%%%%%%%%%%%%%%%%%%%%%%%%% Emplacements chambre %%%%%%%%%%%%%%%%%%%%%%%%%
% CR_D0
description(chambre) :- 
        write("Le soleil se lève, amenant une douce éclaircie sur la {porte} de votre chambre."), nl, 
        write("Vous avez fait votre {lit}, celui-ci semble désormais si moelleux..."), nl,
        write("Mais, quelques livres sont posés sur votre {etagere}, n'attendant que vous pour les prendre et vous asseoir en face de votre {bureau} les lire."), nl, nl,
        write("Où voulez-vous ALLER ?"), nl.

% CR_D1
description(lit) :- 
        write("Vous vous approchez du lit. Celui-ci semble moelleux et accueillant."), nl, 
        write("Misty, votre [chat], vous regarde avec des yeux ronds, semblant attendre quelque chose de vous."), nl, 
        write("Un [poster] est accroché sur le mur, au-dessus du lit."), nl, 
        write("Une petite [peluche] est posée à côté de votre oreiller."), nl.

% CR_D2
description(etagere) :-
        write("Vous vous approchez de l'étagère. Sur celle-ci il y a deux livres, un de [Maths] et un de [Logique]."), nl, 
        write("Un [origami] fait-main est également posé sur cette étagère."), nl.

% CR_D3
description(bureau) :-
        write("Vous vous approchez du bureau. Un [carnet] est mis en évidence au milieu de celui-ci. Une [photo] encadrée est soutenu par un [triangle] peu commun."), nl.

% CR_Ov
description(porte) :-
        interactedList(Interacted),
        list_check(porte, Interacted),
        write("Vous mettez la main sur la poignée, votre chat miaule et demande une caresse, mieux vaut lui dire au revoir avant de partir."), nl.

% CR_Ov
description(porte) :-
        write("Vous ouvrez la porte, et sortez de votre chambre."), nl.

% ?
description(hub) :-
        write("Vous êtes au hub").


%%%%%%%%%%%%%%%%%%%%%%%%% Objets chambre %%%%%%%%%%%%%%%%%%%%%%%%%

% CR_F_01
description(chat) :-
        interactedList(Interacted),
        list_check(chat, Interacted),
        write("Misty est partie en courant en dehors de la chambre."), nl.

% CR_F_01
description(chat) :-
        write("Misty, votre petit chat noir, se dresse sur le lit en vous observant. Elle miaule dans votre direction."), nl.

% CR_F_02
description(poster) :-
        write("C'est un poster du film 'Inception'. On y voit 6 personnages dans une ville distordue par la réalité des rêves."), nl.

% CR_F_03
description(peluche) :-
        write("Une peluche en forme de T-Rex que vous avez obtenu plus jeune, en allant à la fête foraine avec votre famille."), nl.

description(origami) :-
        interactedList(Interacted),
        list_check(origami, Interacted),
        write("Un origami en forme de renard que vous avez réalisé durant une conférence sur les origamis."), nl, 
        write("Vous êtes fier de l'avoir remis à neuf."), nl.

% CR_F_05
description(origami) :-
        write("Un origami en forme de renard que vous avez réalisé durant une conférence sur les origamis."), nl, 
        write("Celui-ci semble être courbé au niveau du museau."), nl.

% CR_F_07
description(maths) :-
        write("Le livre de Maths a pour titre 'Maths, Application et Algèbre'."), nl,
        write("La poussière l'envahit, il ne semble pas avoir été ouvert depuis longtemps."), nl.

% CR_F_09
description(logique) :-
        write("Le livre de Logique a pour titre 'Logique, Illogique, et Démontrer par l'Absurdité'."), nl,
        write("Contrairement à son confrère, ce livre semble avoir été acheté récemment, il est en parfait état."), nl.

% CR_F_11
description(photo) :-
        write("Un selfie de vous et vos amis, autour d'un superbe feu de camp dans la forêt."), nl,
        write("La photo a été mise dans un très joli cadre afin de ne pas abimer ce précieux souvenir."), nl.

% CR_F_13
description(triangle) :-
        write("Ce triangle est une représentation du triangle impossible en version miniaturisé. Vous l'avez obtenu durant une visite au musée des illusions."), nl.

% CR_F_15
description(carnet) :-
        write("Un simple carnet que vous venez d'acheter, est posé sur le bureau, sur sa couverture se trouve un stylo qui vous a suivi toute votre vie puisqu'il ne vous a jamais failli depuis le début de vos études. En même temps vous ne l'avez pas beaucoup utilisé."), nl.


% CR_O_01
interaction(chat) :-
        interactedList(Interacted),
        list_check(chat, Interacted),
        write("Misty est partie en courant en dehors de la chambre."), nl.

% CR_O_01
interaction(chat) :-
        write("Vous caressez Misty, elle se met à ronronner et se colle à vous. En continuant de la caresser, vous remarquez quelque chose coincé dans ses poils."), nl, nl,
        write("        *Vous obtenez 1x Fragment de Clé*"), nl, nl,
        write("Par malheur, vous lui avez tiré des poils, Misty fait un bond et s'enfuit de la pièce."), nl,
        write("Il faut partir à sa recherche !"), nl.

% CR_V_01
interaction(poster) :-
        inventory(Inventory),
        list_check(carnet, Inventory),
        interactedList(InteractedList),
        list_check(poster, InteractedList),
        write("Vous avez déjà noté tout ce qui était intéréssant sur ce poster."), nl.

% CR_V_01
interaction(poster) :-
        inventory(Inventory),
        list_check(carnet, Inventory),
        write("Vous vous approchez du poster de 'Inception'."), nl,
        write("Les personnages semblent être libre de leurs mouvements."), nl,
        write("A travers le poster, ils se rapprochent de vous."), nl,
        write("Vous clignez des yeux. Les personnages sont revenus à leurs positions initiales."), nl,
        write("Cela n'était que votre imagination."), nl,
        write("Vous décidez de noter cette drôle d'anecdote dans votre carnet."), nl.

% CR_V_01
interaction(poster) :-
        write("Vous vous approchez du poster de 'Inception'."), nl,
        write("Vous vous imaginez que les personnages de l'affiche se mettent à bouger."), nl,
        write("Cela vous remémore de bons souvenirs du film."), nl.

% CR_F_04
interaction(peluche) :-
        write("Vous serrez la peluche fort dans vos bras, qu'importe votre âge, l'enfant en vous est heureux d'avoir fait ça et se sent déterminer à continuer."), nl.

% CR_F_06
interaction(origami) :-
        interactedList(Interacted),
        list_check(origami, Interacted),
        write("Vous dépliez le museau du petit renard, l'origami est à nouveau tout neuf."), nl.

% CR_F_06
interaction(origami) :-
        write("Vous avez déjà remis l'origami est à neuf."), nl.

% CR_F_08
interaction(maths) :-
        interactedList(Interacted),
        list_check(maths, Interacted),
        write("Non, plus jamais je ne le toucherai !"), nl.

% CR_F_08
interaction(maths) :-
        write("Vous prenez le livre de Mathématiques de votre bibliothèque, et ouvrez au milieu de celui-ci."), nl,
        write("Une vision de nombreux symboles mathématiques vous agresse l'esprit !"), nl,
        write("Par réflexe de survie, vous refermez rapidement ce livre démoniaque et le rangez de nouveau sur l'étagère."), nl,
        write("Vous vous promettez de ne plus jamais y toucher."), nl.

% CR_F_10
interaction(logique) :-
        write("Ce livre édité par Pierre Hyvernat semble divin."), nl,
        write("Celui-ci vous a ouvert les yeux sur les différents aspects de notre monde."), nl,
        write("Désormais, vous arrivez à résonner de façon plus clair et obtiendrez plus de points au partiel de Logique arrivant la semaine prochaine."), nl.

% CR_F_12
interaction(photo) :-
        write("Vous vous remémorez l'ambiance de ce feu de camp. Le parfum des brochettes puis des chamallow pendant que vous vous racontiez diverses histoires, tantôt drôles, tantôt terrifiantes."), nl,
        write("Une envie de refaire ce genre de soirée vous parvient à l'esprit pendant qu'une larme de nostalgie coule sur votre joue."), nl.

% CR_F_14
interaction(triangle) :-
        write("En voyant ce triangle de forme impossible si singulière, vous vous rappelez les plus grandes illusions du musée que vous avez visité."), nl,
        write("Les étoiles plein les yeux, vous décidez de reprendre le parcours de votre chambre."), nl.

% CR_V_00
interaction(carnet) :-
        interactedList(Interacted),
        list_check(carnet, Interacted),
        write("Vous avez déjà récupéré le carnet."), nl.

% CR_V_00
interaction(carnet) :-
        write("Vous décidez que ces ustensiles vous seront utiles pour aujourd'hui et les prenez avec vous."), nl, nl,
        write("        [*Vous obtenez un [Carnet & Stylo]*]"), nl, nl.
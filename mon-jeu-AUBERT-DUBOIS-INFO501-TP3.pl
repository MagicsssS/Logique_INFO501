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
passage(chambre, porte, hub). %Ov
passage(chambre, lit, lit). %D1
passage(chambre, etagere, etagere). %D2
passage(chambre, bureau, bureau). %D3


% position des objets
position(chat, lit). %F_01
position(poster, lit). %F_02


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
        decrire(X),
        write("OK."), nl,
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
        list_add(X, Interacted, NewList)
        retract(interactedList(_)),
        assert(interactedList(NewList)).
        write("OK."), nl,
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



% regarder autour de soi
analyseSalle :-
        position_courante(Place),
        decrire(Place), nl.


% fin de partie
fin :-
        nl, write("La partie est finie."), nl,
        halt.


% affiche les instructions du jeu
instructions :-
        nl,
        write("Les commandes doivent être données avec la syntaxe Prolog habituelle."), nl,
        write("Les commandes existantes sont :"), nl,
        write("jouer.                   -- pour commencer une partie."), nl,
        write("n.  s.  e.  o.           -- pour aller dans cette direction (nord / sud / est / ouest)."), nl,
        write("aller(direction)         -- pour aller dans cette direction."), nl,
        write("observer.                -- pour regarder quelque chose."), nl,
        write("interagir.               -- pour interagir avec quelque chose."), nl,
        write("inventaire.              -- pour analyser votre inventaire"),
        write("instructions.            -- pour revoir ce message !"), nl,
        write("fin.                     -- pour terminer la partie et quitter."), nl,
        nl.



% lancer une nouvelle partie
jouer :-
        instructions,
        analyseSalle.


% descriptions des emplacements
decrire(chambre) :-
        write("Le soleil se lève, amenant une douce éclaircie sur la {porte} de votre chambre."), nl, 
        write("Vous avez fait votre {lit}, celui-ci semble désormais si moelleux..."), nl,
        write("Mais, quelques livres sont posés sur votre {etagere}, n'attendant que vous pour les prendre et vous asseoir en face de votre {bureau} les lire."), nl, nl,
        write("Où voulez-vous ALLER ?"), nl.

decrire(lit) :-
        write("Vous vous approchez du lit. Celui-ci semble moelleux et accueillant."), nl, 
        write("Misty, votre [chat], vous regarde avec des yeux ronds, semblant attendre quelque chose de vous."), nl, 
        write("Un [poster] est accroché sur le mur, au-dessus du lit."), nl, 
        write("Une petite [peluche] est posée à côté de votre oreiller."), nl.

decrire(etagere) :-
        write("Vous vous approchez de l'étagère. Sur celle-ci il y a deux livres, un de [Maths] et un de [Logique]."), nl, 
        write("Un [origami] fait-main est également posé sur cette étagère."), nl.

decrire(bureau) :-
        write("Vous vous approchez du bureau. Un [carnet] est mis en évidence au milieu de celui-ci. Une [photo] encadrée est soutenu par un [triangle] peu commun."), nl.

decrire(chat) :-
        interactedList(Interacted),
        list_check("O_01", Interacted).



package Acme::MetaSyntactic::metro;
use strict;
use Acme::MetaSyntactic::MultiList;
our @ISA = qw( Acme::MetaSyntactic::MultiList );
__PACKAGE__->init();
1;

=head1 NAME

Acme::MetaSyntactic::metro - The metro theme

=head1 DESCRIPTION

This theme lists all the active stations of several subway lines.

=head2 List of cities included

All themes are divided into lines, according to the local nomenclature,
e.g. C<fr/paris/ligne_5>.

This theme currently includes the stations for the following cities:

=over 4

=item *

C<fr/paris>: Paris, France, 16 lines.

=item *

C<fr/lyon>: Lyon, France, 4 lines.

=item *

C<fr/marseille>: Marseille, France, 2 lines.

=item *

C<fr/rennes>: Rennes, France, 1 line.

=item *

C<fr/lille>: Lille, France, 2 lines.

=item *

C<nl/amsterdam>: Amsterdam, Netherlands, 5 lines.

=item *

C<au/vienna>: Vienna, Austria, 5 lines.

=item * 

C<pt/porto>: Port, Portugal, 4 lines.

=item * 

C<us/chicago>: Chicago, United States, 8 lines.

=item *

C<uk/london>: London, United Kingdom, 12 lines.

=item *

C<nl/rotterdam>: Rottedam, Netherlands, 2 lines.

=item *

C<ca/toronto>: Toronto, Canada, 4 lines.

=back

According to Abigail, the addition of the London Tube stations to
C<Acme::MetaSyntactic> makes for another milestone: we can now use B<meta>
to play I<Mornington Crescent>.

=head1 CONTRIBUTOR

Philippe 'BooK' Bruhat

Introduced in version 0.83, published on July 17, 2006.

Updated with station names for Lyon, Marseille, Lille, Rennes (with
stations grouped by line) in version 0.88, published on August 21, 2006.

Updated by Elliot Shank with the Chicago metro and by Abigail with
the London Tube, Rotterdam and Toronto metro lines in version 0.91,
published on September 11, 2006.

=head1 DEDICATION

This module is dedicated to the Paris subway, which was opened to the
public on July 19, 1900.

=head1 SEE ALSO

L<Acme::MetaSyntactic>, L<Acme::MetaSyntactic::MultiList>.

=cut

__DATA__
# default
fr/paris
# names fr paris ligne_1
La_Defense_Grande_Arche
Esplanade_de_la_Defense
Pont_de_Neuilly
Les_Sablons
Porte_Maillot
Argentine
Charles_de_Gaulle_Etoile
George_V
Franklin_D_Roosevelt
Champs_Elysees_Clemenceau
Concorde
Tuileries
Palais_Royal_Musee_du_Louvre
Louvre_Rivoli
Chatelet
Hotel_de_ville
Saint_Paul
Bastille
Gare_de_Lyon
Reuilly_Diderot
Nation
Porte_de_Vincennes
Saint_Mande
Berault
Chateau_de_Vincennes
# names fr paris ligne_2
Porte_Dauphine
Victor_Hugo
Charles_de_Gaulle_Etoile
Ternes
Courcelles
Monceau
Villiers
Rome
Place_de_Clichy
Blanche
Pigalle
Anvers
Barbes_Rochechouart
La_Chapelle
Stalingrad
Jaures
Colonel_Fabien
Belleville
Couronnes
Menilmontant
Pere_Lachaise
Philippe_Auguste
Alexandre_Dumas
Avron
Nation
# names fr paris ligne_3
Pont_de_Levallois_Becon
Anatole_France
Louise_Michel
Porte_de_Champerret
Pereire
Wagram
Malsherbes
Villiers
Europe
Saint_Lazare
Havre_Caumartin
Opera
Quatre_Septembre
Bourse
Sentier
Reaumur_Sebastopol
Arts_et_Metiers
Temple
Republique
Parmentier
Rue_Saint_Maur
Pere_Lachaise
Gambetta
Porte_de_Bagnolet
Gallieni
# names fr paris ligne_3bis
Porte_des_Lilas
Saint_Fargeau
Pelleport
Gambetta
# names fr paris ligne_4
Porte_de_Clignancourt
Simplon
Marcadet_Poissonniers
Chateau_Rouge
Barbes_Rochechouart
Gare_du_Nord
Gare_de_l_Est
Chateau_d_Eau
Strasbourg_Saint_Denis
Reaumur_Sebastopol
Etienne_Marcel
Les_Halles
Chatelet
Cite
Saint_Michel
Odeon
Saint_Germain_des_Pres
Saint_Sulpice
Saint_Placide
Montparnasse_Bienvenue
Vavin
Raspail
Denfert_Rochereau
Mouton_Duvernet
Alesia
Porte_d_Orleans
# names fr paris ligne_5
Bobigny_Pablo_Picasso
Bobigny_Pantin_Raymond_Queneau
Eglise_de_Pantin
Hoche
Porte_de_Pantin
Ourcq
Laumiere
Jaures
Stalingrad
Gare_du_Nord
Gare_de_l_Est
Jacques_Bonsergent
Republique
Oberkampf
Richard_Lenoir
Breguet_Sabin
Bastille
Quai_de_la_Rapee
Gare_d_Austerlitz
Saint_Marcel
Campo_Formio
Place_d_Italie
# names fr paris ligne_6
Charles_de_Gaulle_Etoile
Kleber
Boissiere
Trocadero
Passy
Bir_Hakeim
Dupleix
La_Motte_Picquet_Grenelle
Cambronne
Sevres_Lecourbe
Pasteur
Montparnasse_Bienvenue
Edgar_Quinet
Raspail
Denfert_Rochereau
Saint_Jacques
Glaciere
Corvisart
Place_d_Italie
Nationale
Chevaleret
Quai_de_la_Gare
Bercy
Dugommier
Daumesnil
Bel_Air
Picpus
Nation
# names fr paris ligne_7
La_Courneuve_8_Mai_1945
Fort_d_Aubervilliers
Aubervilliers_Pantin_Quatre_Chemins
Porte_de_la_Villette
Corentin_Cariou
Crimee
Riquet
Stalingrad
Louis_Blanc
Chateau_Landon
Gare_de_l_Est
Poissonniere
Cadet
Le_Peletier
Chaussee_d_Antin_La_Fayette
Opera
Pyramides
Palais_Royal_Musee_du_Louvre
Pont_Neuf
Chatelet
Pont_Marie
Sully_Morland
Jussieu
Place_Monge
Censier_Daubenton
Les_Gobelins
Place_d_Italie
Tolbiac
Maison_Blanche
Porte_d_Italie
Porte_de_Choisy
Porte_d_Ivry
Pierre_Curie
Mairie_d_Ivry
Le_Kremlin_Bicetre
Villejuif_Leo_Lagrange
Villejuif_Paul_Vaillant_Couturier
Villejuif_Louis_Aragon
# names fr paris ligne_7bis
Louis_Blanc
Jaures
Bolivar
Buttes_Chaumont
Botzaris
Place_des_Fetes
Pre_Saint_Gervais
# names fr paris ligne_8
Balard
Lourmel
Boucicaut
Felix_Faure
Commerce
La_Motte_Picquet_Grenelle
Ecole_Militaire
La_Tour_Maubourg
Invalides
Concorde
Madeleine
Opera
Richelieu_Drouot
Grands_Boulevards
Bonne_Nouvelle
Strasbourg_Saint_Denis
Republique
Filles_du_Calvaire
Saint_Sebastien_Froissart
Chemin_Vert
Bastille
Ledru_Rollin
Faidherbe_Chaligny
Reuilly_Diderot
Montgallet
Daumesnil
Michel_Bizot
Porte_Doree
Porte_de_Charenton
Liberte
Charenton_Ecoles
Ecole_Veterinaire_de_Maisons_Alfort
Maisons_Alfort_Stade
Maisons_Alfort_Les_Juilliottes
Creteil_l_Echat
Creteil_Universite
Creteil_Prefecture
# names fr paris ligne_9
Pont_de_Sevres
Billancourt
Marcel_Sembat
Porte_de_Saint_Cloud
Exelmans
Michel_Ange_Molitor
Michel_Ange_Auteuil
Jasmin
Ranelagh
La_Muette
Rue_de_la_Pompe
Trocadero
Iena
Alma_Marceau
Franklin_D_Roosevelt
Saint_Philippe_du_Roule
Miromesnil
Saint_Augustin
Havre_Caumartin
Chaussee_d_Antin_La_Fayette
Richelieu_Drouot
Grands_Boulevards
Bonne_Nouvelle
Strasbourg_Saint_Denis
Republique
Oberkampf
Saint_Ambroise
Voltaire
Charonne
Rue_des_Boulets
Nation
Buzenval
Maraichers
Porte_de_Montreuil
Robespierre
Croix_de_Chavaux
Mairie_de_Montreuil
# names fr paris ligne_10
Porte_d_Auteuil
Michel_Ange_Auteuil
Eglise_d_Auteuil
Boulogne_Pont_de_Saint_Cloud
Boulogne_Jean_Jaures
Michel_Ange_Molitor
Chardon_Lagache
Mirabeau
Javel_Andre_Citroen
Charles_Michels
Avenue_Emile_Zola
La_Motte_Picquet_Grenelle
Segur
Duroc
Vaneau
Sevres_Babylone
Mabillon
Odeon
Cluny_la_Sorbonne
Maubert_Mutualite
Cardinal_Lemoine
Jussieu
Gare_d_Austerlitz
# names fr paris ligne_11
Mairie_des_Lilas
Porte_des_Lilas
Telegraphe
Place_des_Fetes
Jourdain
Pyrenees
Belleville
Goncourt
Republique
Arts_et_Metiers
Rambuteau
Hotel_de_Ville
Chatelet
# names fr paris ligne_12
Porte_de_la_Chapelle
Marx_Dormoy
Marcadet_Poissonniers
Jules_Joffrin
Lamarck_Caulaincourt
Abbesses
Pigalle
Saint_Georges
Notre_Dame_de_Lorette
Trinite_d_Estienne_d_Orves
Saint_Lazare
Madeleine
Concorde
Assemblee_Nationale
Solferino
Rue_du_Bac
Sevres_Babylone
Rennes
Notre_Dame_des_Champs
Montparnasse_Bienvenue
Falguiere
Pasteur
Volontaires
Vaugirard
Convention
Porte_de_Versailles
Corentin_Celton
Mairie_d_Issy
# names fr paris ligne_13
Mairie_de_Saint_Ouen
Garibaldi
Porte_de_Saint_Ouen
Guy_Moquet
Saint_Denis_Universite
Basilique_de_Saint_Denis
Saint_Denis_Porte_de_Paris
Carrefour_Pleyel
Gabriel_Peri_Asnieres_Gennevilliers
Mairie_de_Clichy
Porte_de_Clichy
Brochant
La_Fourche
Place_de_Clichy
Liege
Saint_Lazare
Miromesnil
Saint_Philippe_du_Roule
Champs_Elysees_Clemenceau
Invalides
Varenne
Saint_Francois_Xavier
Duroc
Montparnasse_Bienvenue
Gaite
Pernety
Plaisance
Porte_de_Vanves
Malakoff_Plateau_de_Vanves
Malakoff_Rue_Etienne_Dolet
Chatillon_Montrouge
# names fr paris ligne_14
Saint_Lazare
Madeleine
Pyramides
Chatelet
Gare_de_Lyon
Bercy
Cour_Saint_Emilion
Bibliotheque_Francois_Mitterrand
# names fr lyon ligne_A
Perrache
Ampere_Victor_Hugo
Bellecour
Cordelier
Hotel_de_Ville
Foch
Massena
Charpennes
Republique
Gratte_Ciel
Flachet
Cusset
Laurent_Bonnevay
# names fr lyon ligne_B
Stade_de_Gerland
Debourg
Place_Jean_Jaures
Jean_Mace
Saxe_Gambetta
Place_Guichard
Part_Dieu
Brotteaux
Charpennes
# names fr lyon ligne_C
Hotel_de_Ville
Croix_Paquet
Croix_Rousse
Henon
Cuire
# names fr lyon ligne_D
Gare_de_Venissieux
Parilly
Mermoz_Pinel
Laennec
Grange_Blanche
Monplaisir_Lumiere
Sans_Souci
Garibaldi
Saxe_Gambetta
Guillotiere
Bellecour
Vieux_Lyon
Gorge_de_Loup
Valmy
Gare_de_Vaise
# names fr marseille ligne_1
La_Timone
Baille
Castellane
Estrangin_Prefecture
Vieux_Port_Hotel_de_ville
Colbert_Hotel_de_region
St_Charles
Reformes_Canebiere
Cinq_avenues_Longchamp
Chartreux
St_Just_Hotel_de_departement
Malpasse
Frais_Vallon
La_Rose
# names fr marseille ligne_2
Bougainville
National
Desiree Clary
Joliette
Jules_Guesde
St_Charles
Noailles
Notre_Dame_du_Mont_Cours_Julien
Castellane
Perier
Rond_point_du_Prado
Sainte_Marguerite_Dromel
# names fr rennes
J_F_Kennedy
Villejean_Universite
Pontchaillou
Anatole_France
Ste_Anne
Republique
Charles_de_Gaulle
Gares
Jacques_Cartier
Clemenceau
Henri_Freville
Italie
Triangle
Blosne
La_Poterie
# names fr lille ligne_1
Quatre_Cantons
Cite_Scientifique
Triolo
Villeneuve_d_Ascq_Hotel_de_Ville
Pont_de_Bois
Lezennes
Hellemmes
Marbrerie
Fives
Caulier
Gare_Lille_Flandres
Rihour
Republique_Beaux_Arts
Gambetta
Wazemmes
Porte_des_Postes
CHR_Oscar_Lambret
CHR_B_Calmette
# names fr lille ligne_2
St_Philibert
Bourg
Maison_des_Enfants
Mitterie
Pont_Superieur
Lomme_Lambersart
Canteleu
Bois_Blancs
Port_de_Lille
Cormontaigne
Montebello
Porte_des_Postes
Porte_d_Arras
Porte_de_Douai
Porte_de_Valenciennes
Lille_Grand_Palais
Mairie_de_Lille
Gare_Lille_Flandres
Gare_Lille_Europe
Saint_Maurice_Pellevoisin
Mons_Sarts
Mairie_de_Mons
Fort_de_Mons
Les_Pres
Jean_Jaures
Wasquehal_Pave_de_Lille
Wasquehal_Hotel_de_Ville
Croix_Centre
Croix_Marie
Epeule_Montesquieu
Roubaix_Charles_de_Gaulle
Euroteleport
Roubaix_Grand_Place
Gare_Jean_Lebas
Alsace
Mercure
Carliers
Tourcoing_Sebastopol
Tourcoing_Centre
Colbert
Phalempins
Pont_de_Neuville
Bourgogne
CH_Dron
# names nl amsterdam metrolijn_50
Isolatorweg
Sloterdijk_NS
De_Vlugtlaan
Jan_van_Galenstraat
Postjesweg
Lelylaan_NS
Heemstedestraat
Henk_Sneevlietweg
Amstelveenseweg
Zuid_WTC_NS
RAI_NS
Overamstel
Van_der_Madeweg
Duivendrecht_NS
Standvliet_Arena
Bijlmer_NS
Bullewijk
Holendrecht
Reigersbos
Gein
# names nl amsterdam metrolijn_51
Centraal_Station
Nieuwmarkt
Waterlooplein
Weesperplein
Wibautstraat
Amstel_NS
Spaklerweg
Overamstel
RAI_NS
Zuid_WTC_NS
Boelelaan_VU
A_J_Ernststraat
Van_Boshuizenstraat
Uilenstede
Kronenburg
Zonnestein
Onderuit
Oranjebaan
Amstelveen_Centrum
Ouderkerkerlaan
Sportlaan
Marne
Gondel
Meent
Brink
Poortwachter
Spinnerij
Sacharovlaan
Westwijk
# names nl amsterdam metrolijn_52
Van_Hasseltweg
Centraal_Station
Rokin
Vijzelgracht
Ceintuurbaan
Europaplein
Zuid_WTC
# names nl amsterdam metrolijn_53
Centraal_Station
Nieuwmarkt
Waterlooplein
Weesperplein
Wibautstraat
Amstel_NS
Spaklerweg
Van_der_Madeweg
Venserpolder
Diemen_Zuid_NS
Verrijn_Stuartweg
Ganzenhoef
Kraaiennest
Gaasperplas
# names nl amsterdam metrolijn_54
Centraal_Station
Nieuwmarkt
Waterlooplein
Weesperplein
Wibautstraat
Amstel_NS
Spaklerweg
Van_der_Madeweg
Duivendrecht_NS
Standvliet_Arena
Bijlmer_NS
Bullewijk
Holendrecht
Reigersbos
Gein
# names au vienna u1
Kagran
Alte_Donau
Kaisermuhlen_Vienna_International_Centre
Donauinsel
Vorgartenstrasse
Praterstern
Nestroyplatz
Schwedenplatz
Stephansplatz_City
Karlsplatz
Taubstummengasse
Sudtiroler_Platz
Keplerplatz
Reumannplatz
# names au vienna u2
Schottenring
Schottentor_Universitat
Rathaus
Volkstheater
Museumsquartier
Karlsplatz
# names au vienna u3
Ottakring
Kendlerstrasse
Hutteldorfer Strasse
Johnstrasse
Schweglerstrasse
Westbahnhof
Zieglergasse
Neubaugasse
Volkstheater
Herrengasse
Stephansplatz_City
Stubentor
Landstrasse
Rochusgasse
Kardinal_Nagl_Platz
Schlachthausgasse
Erdberg
Gasometer
Zippererstrasse
Enkplatz
Simmering
# names au vienna u4
Hutteldorf
Ober_St_Veit
Unter_St_Veit
Braunschweiggasse
Hietzing
Schonbrunn
Meidling Hauptstrasse
Langenfeldgasse
Margaretengurtel
Pilgramgasse
Kettenbruckengasse
Karlsplatz
Stadtpark
Landstrasse
Schwedenplatz
Schottenring
Rossauer_Lande
Friedensbrucke
Spittelau
Heiligenstadt
# names au vienna u6
Floridsdorf
Neue_Donau
Handelskai
Dresdner_Strasse
Jagerstrasse
Spittelau
Nussdorfer_Strasse
Wahringer_Strasse_Volksoper
Michelbeuern_Allgemeines_Krankenhaus
Alser_Strasse
Josefstadter_Strasse
Thaliastrasse
Burggasse_Stadthalle
Westbahnhof
Gumpendorfer_Strasse
Langenfeldgasse
Niederhofstrasse
Philadelphiabrucke_Meidling
Tscherttegasse
Am_Schopfwerk
Alterlaa
Erlaaer_Strasse
Perfektastrasse
Siebenhirten
# names pt porto linha_A
Senhor_de_Matosinhos
Mercado
Brito_Capelo
Matosinhos_Sul
Camara_Matosinhos
Parque_de_Real
Pedro_Hispano
Estadio_do_Mar
Vasco_da_Gama
Senhora_da_Hora
Sete_Bicas
Viso
Ramalde
Francos
Casa_da_Musica
Carolina_Michaelis
Lapa
Trindade
Bolhao
Campo_24_de_Agosto
Heroismo
Campanha
Estadio_do_Dragao
# names pt porto linha_B
Pedras_Rubras
Crestins
Esposade
Custoias
Fonte_do_Cuco
Senhora_da_Hora
Sete_Bicas
Viso
Ramalde
Francos
Casa_da_Musica
Carolina_Michaelis
Lapa
Trindade
Bolhao
Campo_24_de_Agosto
Heroismo
Campanha
Estadio_do_Dragao
# names pt porto linha_C
Trofa
Senhora_das_Dores
Pateiras
Bougado
Serra
Muro
Ribela
ISMAI
Castelo_da_Maia
Mandim
Zona_Industrial
Forum
Parque_da_Maia
Custio
Araujo
Pias
Candido_dos_Reis
Fonte_do_Cuco
Senhora_da_Hora
Sete_Bicas
Viso
Ramalde
Francos
Casa_da_Musica
Carolina_Michaelis
Lapa
Trindade
Bolhao
Campo_24_de_Agosto
Heroismo
Campanha
Estadio_do_Dragao
# names pt porto linha_D
Camara_Gaia
General_Torres
Jardim_do_Morro
S_Bento
Aliados
Trindade
Faria_Guimaraes
Marques
Combatentes
Salgueiros
Polo_Universitario
# names us chicago red
Ninety_Fifth
Eighty_Seventh
Seventy_Ninth
Sixty_Ninth
Sixty_Third
Garfield
Forty_Seventh
Sox_Thirty_Fifth
Cermak_Chinatown
Roosevelt
Harrison
Jackson
Monroe
Washington
Grand
Chicago
Clark_and_Division
North_and_Clybourn
Fullerton
Belmont
Addison
Sheridan
Wilson
Lawrence
Argyle
Berwyn
Bryn_Mawr
Thorndale
Granville
Loyola
Morse
Jarvis
Howard
# names us chicago blue
O_Hare
Rosemont
Cumberland
Harlem
Jefferson_Park
Montrose
Irving_Park
Addison
Belmont
Logan_Square
California
Western
Damen
Division
Chicago
Grand
Clark_and_Lake
Washington
Monroe
Jackson
LaSalle
Clinton
UIC_Halsted
Racine
Medical_Center
Western
Kedzie_Homan
Pulaski
Cicero
Austin
Oak_Park
Harlem
Forest_Park
Polk
Eighteenth
Damen
Western
California
Kedzie
Central_Park
Pulaski
Kildare
Cicero
Fifty_Fourth_and_Cermak
# names us chicago purple
Linden
Central
Noyes
Foster
Davis
Dempster
Main
South_Boulevard
Howard
Belmont
Wellington
Diversey
Fullerton
Armitage
Sedgwick
Chicago
Merchandise_Mart
Clark_and_Lake
State_and_Lake
Randolph
Madison
Adams
Library
LaSalle_and_Van_Buren
Quincy
Washington_and_Wells
# names us chicago yellow
Dempster
Howard
# names us chicago brown
Kimball
Kedzie
Francisco
Rockwell
Western
Damen
Montrose
Irving_Park
Addison
Paulina
Southport
Belmont
Wellington
Diversey
Fullerton
Armitage
Sedgwick
Chicago
Merchandise_Mart
Washington_and_Wells
Quincy
LaSalle_and_Van_Buren
Library
Adams
Madison
Randolph
State_and_Lake
Clark_and_Lake
# names us chicago orange
Midway
Pulaski
Kedzie
Western
Thirty_Fifth_and_Archer
Ashland
Halsted
Roosevelt
Library
LaSalle_and_Van_Buren
Quincy
Washington_and_Wells
Clark_and_Lake
State_and_Lake
Randolph
Madison
Adams
# names us chicago green
Harlem_and_Lake
Oak_Park
Ridgeland
Austin
Central
Laramie
Cicero
Pulaski
Conservatory_Central_Park_Drive
Kedzie
California
Ashland
Clinton
Clark_and_Lake
State_and_Lake
Randolph
Madison
Adams
Roosevelt
Thirty_Fifth_Bronzeville_IIT
Indiana
Forty_Third
Forty_Seventh
Fifty_First
Garfield
King_Drive
East_Sixty_Third_and_Cottage_Grove
Halsted
Ashland_and_Sixty_Third
# names us chicago pink
Fifty_Fourth_and_Cermak
Cicero
Kildare
Pulaski
Central_Park
Kedzie
California
Western
Damen
Eighteenth
Polk
Ashland
Clinton
Clark_and_Lake
State_and_Lake
Randolph
Madison
Adams
Library
LaSalle_and_Van_Buren
Quincy
Washington_and_Wells
# names uk london bakerloo_line
Harrow_and_Wealdstone Kenton South_Kenton North_Wembley Wembley_Central
Stonebridge_Park Harlesden Willesden_Junction Kensal_Green Queen_s_Park
Kilburn_Park Maida_Vale Warwick_Avenue Paddington Edgware_Road Marylebone
Baker_Street Regent_s_Park Oxford_Circus Piccadilly_Circus Charing_Cross
Embankment Waterloo Lambert_North Elephant_and_Castle
# names uk london central_line
West_Ruislip Ruislip_Gardens South_Ruislip Northolt Greenford Perivale
Hanger_Lane Ealing_Broadway West_Acton North_Acton East_Acton White_City
Wood_Lane Shepard_s_Bush Holland_Park Notting_Hill_Gate Queensway
Lancaster_Gate Marble_Arch Bond_Street Oxford_Circus Tottenham_Court_Road
Holborn Chancery_Lane St_Paul_s Bank Liverpool_Street Bethnal_Green
Mile_End Stratford Leyton Leytonstone Wanstead Redbridge Gants_Hill
Newbury_Park Barkingside Fairlop Hainault Grange_Hill Chigwell Roding_Valley
Snaresbrook South_Woodford Woodford Buckhurst_Hill Loughton Debden
Theydon_Bois Epping
# names uk london circle_line
Paddington Edgware_Road Baker_Street Great_Portland_Street Euston_Square
King_s_Cross_St_Pancras Farringdon Barbican Moorgate Liverpool_Street
Aldgate Tower_Hill Monument Cannon_Street Mansion_House Blackfriars
Temple Embankment Westminster St_James_s_Park Victoria Sloane_Square
South_Kensington Gloucester_Road High_Street_Kensington Notting_Hill_Gate
Bayswater
# names uk london district_line
Richmond Kew_Gardens Gunnersbury Ealing_Broadway Ealing_Common Acton_Town
Chiswick_Park Turnham_Green Stamford_Brook Ravenscourt_Park Hammersmith
Barons_Court West_Kensington Wimbledon Wimbledon_Park Southfields
East_Putney Putney_Bridge Parsons_Green Fulham_Broadway West_Brompton
Kensington_Olympia Earl_s_Court Gloucester_Road South_Kensington
Sloane_Square Victoria St_James_s_Park Westminster Embankment Temple
Blackfriars Mansion_House Cannon_Street Monument Tower_Hill Aldgate_East
Whitechapel Stepney_Green Mile_End Bow_Road Bromley_by_Bow West_Ham
Plaistow Upton Park East Ham Barking Upney Becontree Dagenham_Heathway
Dagenham_East Elm_Park Hornchurch Upminster_Bridge Upminster
High_Street_Kensington Notting_Hill_Gate Bayswater Paddington Edgware_Road
# names uk london east_london_line
Shoreditch Whitechapel Shadwell Wapping Rotherhithe Canada_Water
Surrey_Quays New_Cross_Gate New_Cross
# names uk london hammersmith_and_city_line
Hammersmith Goldhawk_Road Shepherd_s_Bush Latimer_Road Ladbroke_Grove
Westbourne_Park Royal_Oak Paddington Edgware_Road Baker_Street
Great_Portland_Street Euston_Square King_s_Cross_St_Pancras Farringdon
Barbican Moorgate Liverpool_Street Aldgate_East Whitechapel Stepney_Green
Mile_End Bow_Road Bromley_by_Bow West_Ham Plaistow Upton_Park East_Ham Barking
# names uk london jubilee_line
Stanmore Canons_Park Queensbury Kingsbury Wembley_Park Neasden Dollis_Hill
Willesden_Green Kilburn West_Hampstead Finchley_Road Swiss_Cottage
St_John_s_Wood Baker_Street Bond_Street Green_Park Westminster Waterloo
Southwark London_Bridge Bermondsey Canada_Water Canary_Wharf North_Greenwich
Canning_Town West_Ham Stratford
# names uk london metropolitan_line
Aldgate Liverpool_Street Moorgate Barbican Farringdon King_s_Cross_St_Pancras
Euston_Square Great_Portland_Street Baker_Street Finchley_Road Wembley_Park
Preston_Road Northwick_Park Harrow_on_the_Hill West_Harrow Rayners_Lane
Eastcote Ruislip_Manor Ruislip Ickenham Hillingdon Uxbridge North_Harrow
Pinner Northwood_Hills Northwood Moor_Park Croxley Watford Rickmansworth
Chorleywood Chalfont_Latimer Chesham Amersham
# names uk london northern_line
High_Barnet Totteridge_and_Whetstone Woodside_Park West_Finchley
Mill_Hill_East Finchley_Central East_Finchley Highgate Archway
Tufnell_Park Kentish_Town Edgware Burnt_Oak Colindale Hendon_Central
Brent_Cross Golders_Green Hampstead Belsize_Park Chalk_Farm Camden_Town
Mornington_Crescent Euston Warren_Street Goodge_Street Tottenham_Court_Road
Leicester_Square Charing_Cross Embankment Waterloo Euston
King_s_Cross_St_Pancras Angel Old_Street Moorgate Bank London_Bridge Borough
Elephant_and_Castle Kennington Oval Stockwell Clapham_North Clapham_Common
Clapham_South Balham Tooting_Bec Tooting_Broadway Colliers_Wood
South_Wimbledon Morden
# names uk london piccadilly_line
Cockfosters Oakwood Southgate Arnos_Grove Bounds_Green Wood_Green
Turnpike_Lane Manor_House Finsbury_Park Arsenal Holloway_Road Caledonian_Road
King_s_Cross Russell_Square Holborn Covent_Garden Leicester_Square
Piccadilly_Circus Green_Park Hyde_Park_Corner Knightsbridge South_Kensington
Gloucester_Road Earl_s_Court Barons_Court Hammersmith Turnham_Green
Acton_Town South_Ealing Northfields Boston_Manor Osterley Hounslow_East
Hounslow_Central Hounslow_West Hatton_Cross Heathrow_Terminal_4
Heathrow_Terminals_1_2_3
# names uk london victoria_line
Walthamstow_Central Blackhorse_Road Tottenham_Hale Seven_Sisters
Finsbury_Park Highbury_Islington King_s_Cross_St_Pancras Euston
Warren_Street Oxford_Circus Green_Park Victoria Pimlico Vauxhall
Stockwell Brixton
# names uk london waterloo_and_city_line
Bank Waterloo
# names nl rotterdam erasmus_line
De_Akkers Heemraadlaan Spijkenisse_Centrum Zalmplaat Hoogvliet Tussenwater
Poortugaal Rhoon Slinge Zuidplein Maashaven Rijnhaven Wilhelminaplein
Leuvehaven Beurs Stadhuis Centraal_Station
# names nl rotterdam caland_line
De_Akkers Heemraadlaan Spijkenisse_Centrum Zalmplaat Hoogvliet Tussenwater
Pernis Vijfsluizen Troelstralaan Parkweg Schiedam_Centrum Marconiplein
Delfshaven Coolhaven Dijkzigt Eendrachtsplein Beurs Blaak Oostplein
Gerdesiaweg Voorschotenlaan Kralingen_Zoom Capelsebrug Slotlaan
Capelle_Centrum De_Terp Schenkel Prinsenlaan Oosterflank Alexander
Graskruid Romeynshof Binnenhof Hesseplaats Nieuw_Verlaat Ambachtsland
De_Tochten Nesselande
# names ca toronto yonge_university_spadina
Finch North_York_Centre Sheppard_Yonge York_Mills Lawrence Eglinton
Davisville St_Clair Summerhill Rosedale Bloor_Yonge Wellesley College
Dundas Queen King Union St_Andrew Osgoode St_Patrick Queen_s_Park
Museum St_George Spadina Dupont St_Clair_West Eglinton_West Glencairn
Lawrence_West Yorkdale Wilson Downsview
# names ca toronto bloor_danforth
Kipling Islington Royal_York Old_Mill Jane Runnymede High_Park Keele
Dundas_West Lansdowne Dufferin Ossington Christie Bathurst Spadina
St_George Bay Bloor_Yonge Sherbourne Castle_Frank Broadview Chester
Pape Donlands Greenwood Coxwell Woodbine Main_Street Victoria_Park
Warden Kennedy
# names ca toronto scarborough_rt
Kennedy Lawrence_East Ellesmere Midland Scarborough_Centre McCowan
# names ca toronto sheppard
Sheppard_Yonge Willowdale Bayview Bessarion Leslie Don_Mills


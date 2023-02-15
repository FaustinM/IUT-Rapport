/**
Ville: Id, CodePostal, Nom, LivraisonRetarde
Adresse: Id, Numero, Nom, Complement, Telephone, Ville->Ville->Id
Fournisseur: Id, Nom, Telephone, Email, Adresse->Adresse->Id
Ingredient: Id, Nom, AchatParPortion, StockActuel, Frais, Unite->Unite->Id
Unite: Id, Nom
Periode: Id, Début, Fin
Recette: Id, Nom, Prix, TempsPreparation, TempsCuisson
Ustensile: Id, Nom
Label: Id, Nom, Couleur
RecompenseFoodyz: Id, Nom, Description, Palier
Utilisateur: Id, Email, Nom, Prénom, Téléphone, Motdepasse, EstAmbassadeur, Facturation->Adresse->Id
Commande: Id, Date, Adresse->Adresse->Id, Utilisateur->Utilisateur->Id
**/


DROP TABLE IF EXISTS RecompenseFoodyzUtilisateur;
DROP TABLE IF EXISTS AdresseLivraison;
DROP TABLE IF EXISTS CommandeRecette;
DROP TABLE IF EXISTS RecetteUstensile;
DROP TABLE IF EXISTS RecetteLabel;
DROP TABLE IF EXISTS RecettePeriode;
DROP TABLE IF EXISTS RecetteIngredient;
DROP TABLE IF EXISTS IngredientPeriode;
DROP TABLE IF EXISTS IngredientFournisseur;

DROP TABLE IF EXISTS Commande;
DROP TABLE IF EXISTS Utilisateur;
DROP TABLE IF EXISTS RecompenseFoodyz;
DROP TABLE IF EXISTS Recette;
DROP TABLE IF EXISTS Periode;
DROP TABLE IF EXISTS Label;
DROP TABLE IF EXISTS Ustensile;
DROP TABLE IF EXISTS Ingredient;
DROP TABLE IF EXISTS Unite;
DROP TABLE IF EXISTS Fournisseur;
DROP TABLE IF EXISTS Adresse;
DROP TABLE IF EXISTS Ville;

CREATE TABLE Ville (
    Id INTEGER PRIMARY KEY,
    CodePostal TEXT NOT NULL,
    Nom TEXT NOT NULL,
    LivraisonRetarde BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE TABLE Adresse (
    Id INTEGER PRIMARY KEY,
    Numero INT,
    Nom TEXT NOT NULL,
    Complement TEXT,
    Telephone TEXT CHECK (Telephone GLOB '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    Ville INTEGER,
    FOREIGN KEY(Ville) REFERENCES Ville(Id)
);

CREATE TABLE Fournisseur (
    Id INTEGER PRIMARY KEY,
    Nom TEXT NOT NULL,
    Email TEXT CHECK (Email LIKE '%_@__%.__%'),
    Telephone TEXT CHECK (Telephone GLOB '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    Adresse INTEGER
);

CREATE TABLE Ingredient (
    Id INTEGER PRIMARY KEY,
    Nom TEXT NOT NULL,
    AchatParPortion BOOLEAN DEFAULT FALSE NOT NULL,
    Frais BOOLEAN DEFAULT FALSE NOT NULL,
    StockActuel INTEGER NOT NULL DEFAULT 0 CHECK(StockActuel >= 0),
    Unite INTEGER,
    FOREIGN KEY(Unite) REFERENCES Unite(Id)
);

CREATE TABLE Unite (
    Id INTEGER PRIMARY KEY,
    Nom TEXT NOT NULL
);

CREATE TABLE Ustensile (
    Id INTEGER PRIMARY KEY,
    Nom TEXT NOT NULL
);

CREATE TABLE Label (
    Id INTEGER PRIMARY KEY,
    Nom TEXT NOT NULL,
    Couleur TEXT NOT NULL
);

CREATE TABLE Periode (
    Id INTEGER PRIMARY KEY,
    Debut TEXT NOT NULL,
    Fin TEXT NOT NULL
);

CREATE TABLE Recette (
    Id INTEGER PRIMARY KEY,
    Nom TEXT NOT NULL,
    Prix REAL NOT NULL DEFAULT 0 CHECK(Prix >= 0),
    TempsPreparation INTEGER CHECK(TempsPreparation >= 0),
    TempsCuisson INTEGER CHECK(TempsCuisson >= 0)
);

CREATE TABLE RecompenseFoodyz (
    Id INTEGER PRIMARY KEY,
    Nom TEXT NOT NULL,
    Description TEXT,
    Palier INTEGER NOT NULL CHECK(Palier >= 0)
);

CREATE TABLE Utilisateur (
    Id INTEGER PRIMARY KEY,
    Nom TEXT NOT NULL,
    Prenom TEXT NOT NULL,
    Email TEXT NOT NULL CHECK (Email LIKE '%_@__%.__%'),
    Telephone TEXT NOT NULL CHECK (Telephone GLOB '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    Motdepasse TEXT NOT NULL,
    EstAmbassadeur BOOLEAN DEFAULT FALSE NOT NULL,
    Facturation INTEGER,
    FOREIGN KEY(Facturation) REFERENCES Adresse(Id)
);

CREATE TABLE Commande (
    Id INTEGER PRIMARY KEY,
    Date TEXT NOT NULL,
    Adresse INTEGER,
    Utilisateur INTEGER,
    FOREIGN KEY(Adresse) REFERENCES Adresse(Id),
    FOREIGN KEY(Utilisateur) REFERENCES Utilisateur(Id)
);

/** Table de jointure **/
/**
RecompenseFoodyzUtilisateur: Utilisateur->Utilisateur->Id, _Recompense->RecompenseFoodyz->Id
AdresseLivraison: Utilisateur->Utilisateur->Id, _Adresse->Adresse->Id, AdresseParDefaut
CommandeRecette: Commande->Commande->Id, _Recette->Recette->Id, Portion
RecetteUstensile: Ustensile->Ustensile->Id, _Recette->Recette->Id
RecetteLabel: Label->Label->Id, _Recette->Recette->Id
RecettePeriode: Periode->Periode->Id, _Recette->Recette->Id
RecetteIngredient: Recette->Recette->Id, _Ingredient->Ingredient->Id
IngredientPeriode: Periode->Periode->Id, _Ingredient->Ingredient->Id
IngredientFournisseur: Fournisseur->Fournisseur->Id, _Ingredient->Ingredient->Id
**/

CREATE TABLE RecompenseFoodyzUtilisateur (
    Utilisateur INTEGER NOT NULL,
    Recompense INTEGER NOT NULL,
    PRIMARY KEY (Utilisateur, Recompense),
    FOREIGN KEY (Utilisateur) REFERENCES Utilisateur(Id),
    FOREIGN KEY (Recompense) REFERENCES RecompenseFoodyz(Id)
);

CREATE TABLE AdresseLivraison (
    Utilisateur INTEGER NOT NULL,
    Adresse INTEGER NOT NULL,
    AdresseParDefaut BOOLEAN DEFAULT FALSE NOT NULL,
    PRIMARY KEY (Utilisateur, Adresse),
    FOREIGN KEY (Utilisateur) REFERENCES Utilisateur(Id),
    FOREIGN KEY (Adresse) REFERENCES Adresse(Id)
);

CREATE TABLE CommandeRecette (
    Commande INTEGER NOT NULL,
    Recette INTEGER NOT NULL,
    Portion INTEGER NOT NULL CHECK(Portion > 0),
    PRIMARY KEY (Commande, Recette),
    FOREIGN KEY (Commande) REFERENCES Commande(Id),
    FOREIGN KEY (Recette) REFERENCES Recette(Id)
);

CREATE TABLE RecetteUstensile (
    Ustensile INTEGER NOT NULL,
    Recette INTEGER NOT NULL,
    PRIMARY KEY (Ustensile, Recette),
    FOREIGN KEY (Ustensile) REFERENCES Ustensile(Id),
    FOREIGN KEY (Recette) REFERENCES Recette(Id)
);

CREATE TABLE RecetteLabel (
    Label INTEGER NOT NULL,
    Recette INTEGER NOT NULL,
    PRIMARY KEY (Label, Recette),
    FOREIGN KEY (Label) REFERENCES Label(Id),
    FOREIGN KEY (Recette) REFERENCES Recette(Id)
);

CREATE TABLE RecettePeriode (
    Periode INTEGER NOT NULL,
    Recette INTEGER NOT NULL,
    PRIMARY KEY (Periode, Recette),
    FOREIGN KEY (Periode) REFERENCES Periode(Id),
    FOREIGN KEY (Recette) REFERENCES Recette(Id)
);

CREATE TABLE RecetteIngredient (
    Ingredient INTEGER NOT NULL,
    Recette INTEGER NOT NULL,
    Quantite INTEGER NOT NULL CHECK(Quantite > 0),
    PRIMARY KEY (Ingredient, Recette),
    FOREIGN KEY (Ingredient) REFERENCES Ingredient(Id),
    FOREIGN KEY (Recette) REFERENCES Recette(Id)
);

CREATE TABLE IngredientPeriode (
    Ingredient INTEGER NOT NULL,
    Periode INTEGER NOT NULL,
    PRIMARY KEY (Ingredient, Periode),
    FOREIGN KEY (Ingredient) REFERENCES Ingredient(Id),
    FOREIGN KEY (Periode) REFERENCES Periode(Id)
);

CREATE TABLE IngredientFournisseur (
    Ingredient INTEGER NOT NULL,
    Fournisseur INTEGER NOT NULL,
    PRIMARY KEY (Ingredient, Fournisseur),
    FOREIGN KEY (Ingredient) REFERENCES Ingredient(Id),
    FOREIGN KEY (Fournisseur) REFERENCES Fournisseur(Id)
);
/**
 * !
 * ! Le requête est indiqué dans le rapport
 * !
**/

-- Liste les recette de la semaine avec leur nom et leur prix
/**
 * Cette requête permet d'afficher les recettes commandables sur 
 * la page d'accueil. La gestion des dates est très hasardeuse avec SQLite 
 * comme il n'existe pas d'objet Date, les comparaisons sont donc impossibles
 **/
SELECT Recette.Nom, Recette.Prix
FROM Recette
INNER JOIN RecettePeriode ON Recette.Id = RecettePeriode.Recette
INNER JOIN Periode ON RecettePeriode.Periode = Periode.Id and Periode.Debut = "03/01/2023";

-- Liste les recettes dites Rapide
/**
 * Cette requête permet d'afficher les recettes suivant leur label, on pourrait imaginer un espace d'administration, où un éditeur cherche toutes les recettes correspondant à un label.
 **/
SELECT Recette.Nom, Recette.Prix
FROM Recette
INNER JOIN RecetteLabel ON RecetteLabel.Recette = Recette.Id
INNER JOIN Label ON Label.Id = RecetteLabel.Label
WHERE Label.Nom = "Rapide";

-- Moyenne du prix des portions
/**
 * Cette requête permet de savoir sur quel fourchette se situe nos prix et donc de mettre en relation ce prix avec le prix d'un repas moyen en France.
 **/
SELECT AVG(Recette.Prix), MIN(Recette.Prix), MAX(Recette.Prix)
FROM Recette;

-- Affiche les 10 ingrédients les plus utilisés
/**
 * Cette requête permet d'avoir des informations sur les ingrédients dont on est le plus dépendant, pour améliorer sa relation avec ses fournisseurs.
 **/
SELECT Ingredient.Id, Ingredient.Nom, COUNT(*) as cnt
FROM Ingredient
INNER JOIN RecetteIngredient ON RecetteIngredient.Ingredient = Ingredient.Id
GROUP BY Ingredient.Id, Ingredient.Nom
ORDER BY cnt DESC
LIMIT 10;

-- Affiche les 10 ustensiles les plus utilisés
/**
 * Cette requête permet d'avoir des informations sur les ustensiles dont on est le plus dépendant, pour les intégrer dans notre programme de fidélité ou dans un futur panier repas pour simplifier la vie du client.
 **/
SELECT Ustensile.Id, Ustensile.Nom, COUNT(*) as cnt
FROM Ustensile
INNER JOIN RecetteUstensile ON RecetteUstensile.Ustensile = Ustensile.Id
GROUP BY Ustensile.Id, Ustensile.Nom
ORDER BY cnt DESC
LIMIT 10;

-- Affiche les villes retardés
/**
 * Permet de mieux connaître les conditions de livraisons de ces clients
 **/
SELECT Commande.Id, Ville.CodePostal, Ville.Nom
FROM Ville
INNER JOIN Adresse ON Adresse.Ville = Adresse.Ville
INNER JOIN Commande ON Commande.Adresse = Adresse.Id
WHERE LivraisonRetarde = true;

-- Affiche les données d'une étiquette de livraison pour les commandes du jour
/**
 * Cette requête permet de générer les étiquettes de livraison pour les colis à expédier aujourd'hui. La faible comparaison de date m'empêche de faire sur la période de la semaine ce qui est fait réellement par Foodymix expédiant tous les colis en même temps.
 **/
SELECT Commande.Id, Utilisateur.Nom || " " || Utilisateur.Prenom as Ligne1, Adresse.Complement as Ligne2, Adresse.Telephone as Telephone, Adresse.Numero || " " || Adresse.Nom as Ligne3, Ville.CodePostal || " " || Ville.Nom as Ligne4, Ville.LivraisonRetarde  FROM Commande
INNER JOIN Utilisateur ON Utilisateur.Id = Commande.Utilisateur
INNER JOIN Adresse ON Adresse.Id = Commande.Adresse
INNER JOIN Ville ON Ville.Id = Adresse.Ville
WHERE Commande.Date = strftime('%d/%m/%Y', 'now'); -- La date du 28/09/2022 peut être utilisé

-- Affiche la quantité à commander avec la liste des fournisseurs possibles pour un ingrédient donné et sans stock
SELECT Fournisseur.Nom, Ingredient.Id, Ingredient.Nom, Ingredient.StockActuel, SUM(RecetteIngredient.Quantite*CommandeRecette.Portion) as QuantiteTotale, SUM(RecetteIngredient.Quantite*CommandeRecette.Portion) - Ingredient.StockActuel as Besoin
FROM Commande
INNER JOIN CommandeRecette ON Commande.Id = CommandeRecette.Commande
INNER JOIN Recette ON Recette.Id = CommandeRecette.Recette
INNER JOIN RecetteIngredient ON Recette.Id = RecetteIngredient.Recette
INNER JOIN Ingredient ON Ingredient.Id = RecetteIngredient.Ingredient
INNER JOIN IngredientFournisseur ON Ingredient.Id = IngredientFournisseur.Ingredient
INNER JOIN Fournisseur ON Fournisseur.Id = IngredientFournisseur.Fournisseur
GROUP BY Fournisseur.Id, Ingredient.Id
HAVING Ingredient.StockActuel < QuantiteTotale;

-- Affiche les bonnes quantités pour les ingrédients
SELECT Recette.Nom, CommandeRecette.Portion, RecetteIngredient.Quantite, cast(RecetteIngredient.Quantite*CommandeRecette.Portion as TEXT) || " " ||Unite.Nom as QuantiteCalc FROM Commande
INNER JOIN CommandeRecette ON Commande.Id = CommandeRecette.Commande
INNER JOIN Recette ON Recette.Id = CommandeRecette.Recette
INNER JOIN RecetteIngredient ON Recette.Id = RecetteIngredient.Recette
INNER JOIN Ingredient ON Ingredient.Id = RecetteIngredient.Ingredient
INNER JOIN Unite ON Unite.Id = Ingredient.Unite;

-- Affiche le total des commandes
SELECT Commande.Id, SUM(CommandeRecette.Portion*Recette.Prix) FROM Commande
INNER JOIN CommandeRecette ON Commande.Id = CommandeRecette.Commande
INNER JOIN Recette ON Recette.Id = CommandeRecette.Recette
GROUP BY Commande.Id;

-- Sous requête Panier moyen
SELECT AVG(TotalFacture) FROM (
		SELECT Commande.Id, SUM(CommandeRecette.Portion*Recette.Prix) as TotalFacture FROM Commande
		INNER JOIN CommandeRecette ON Commande.Id = CommandeRecette.Commande
		INNER JOIN Recette ON Recette.Id = CommandeRecette.Recette
		GROUP BY Commande.Id
	);

-- Nb Foodyz
SELECT Utilisateur.Id, SUM(CommandeRecette.Portion)*41
FROM Utilisateur
INNER JOIN Commande ON Commande.Utilisateur = Utilisateur.Id
INNER JOIN CommandeRecette ON Commande.Id = CommandeRecette.Commande
GROUP BY Utilisateur.Id;

-- Liste les points foodyz
SELECT Utilisateur.Id, SUM(CommandeRecette.Portion)*41
FROM Utilisateur
INNER JOIN Commande ON Commande.Utilisateur = Utilisateur.Id
INNER JOIN CommandeRecette ON Commande.Id = CommandeRecette.Commande
GROUP BY Utilisateur.Id;

-- Liste les personnes ayant débloqué le palier 2%
SELECT Utilisateur.Id, Utilisateur.Nom
FROM Utilisateur
INNER JOIN RecompenseFoodyzUtilisateur ON RecompenseFoodyzUtilisateur.Utilisateur = Utilisateur.Id
INNER JOIN RecompenseFoodyz ON RecompenseFoodyzUtilisateur.Recompense = RecompenseFoodyz.Id
WHERE RecompenseFoodyz.Nom = "Mixcover éplucheuse ou bon d'achat et 5% de réduction à vie";

-- Temps total recette
SELECT *, TempsPreparation+TempsCuisson as TempsTotal
FROM Recette;

-- Code promo Ambassadeur
SELECT Utilisateur.Id, Utilisateur.Nom, "AMB_" || Utilisateur.Id || "_" || hex(randomblob(5))
FROM Utilisateur;

-- Récuéprer toutes les recettes compatibles avec un fournisseur et trier par les plus intéréssantes
SELECT Recette.Id, Recette.Nom, SUM(RecetteIngredient.Quantite) as SommeQuantite
FROM Recette
INNER JOIN RecetteIngredient ON RecetteIngredient.Recette = Recette.Id
INNER JOIN Ingredient ON Ingredient.Id = RecetteIngredient.Ingredient
INNER JOIN IngredientFournisseur ON IngredientFournisseur.Ingredient = Ingredient.Id
INNER JOIN Fournisseur ON Fournisseur.Id = IngredientFournisseur.Fournisseur
WHERE Fournisseur.Nom = "Fromage del la mama"
GROUP BY Recette.Id, Recette.Nom
ORDER BY SommeQuantite DESC;

-- Lister les recettes en lien avec des produits en stock
SELECT DISTINCT Recette.Id, Recette.Nom
FROM Recette
INNER JOIN RecetteIngredient ON RecetteIngredient.Recette = Recette.Id
INNER JOIN Ingredient ON Ingredient.Id = RecetteIngredient.Ingredient AND Ingredient.StockActuel > 0;

-- Moyenne de la durée des recettes dites rapides
-- Objectif : S'assurer de la pertinence de ce label
SELECT AVG(TempsPreparation+TempsCuisson)
FROM Recette
INNER JOIN RecetteLabel ON RecetteLabel.Recette = Recette.Id
INNER JOIN Label ON Label.Id = RecetteLabel.Label
WHERE Label.Nom = "Rapide";

-- Liste les recettes les plus commandés d'une période
SELECT Recette.Id, Recette.Nom, RecettePeriode.Periode, COUNT(*) as cnt
FROM Recette
INNER JOIN RecettePeriode ON RecettePeriode.Recette = Recette.Id
INNER JOIN Periode ON Periode.Id = RecettePeriode.Periode
INNER JOIN CommandeRecette ON Recette.Id = CommandeRecette.Recette
INNER JOIN Commande ON Commande.Id = CommandeRecette.Commande
WHERE Periode.Debut = '06/12/2022'
GROUP BY Recette.Id, Recette.Nom, RecettePeriode.Periode
ORDER BY cnt DESC;
# Liste des rapports produits à l'IUT
Ce dépôt contient l'ensemble des rapports de projet que j'ai produits à l'IUT. Ils suivent tous la même charte graphique et sont aux couleurs de l'IUT d'Orsay et de l'Université Paris-Saclay.

## Configuration LaTex
En dehors de certains projets qui utilisent une configuration spéciale, comme le projet S106 ou S105, tous les projets utilisent `faustin.sty` comme support.
Le dossier `Demo`, contient une démonstration de ce thème. 


### Macros
J'ai également quelques macros pour simplifier mon utilisation de LaTex comme :
    - `\q{}` qui permet de faire une citation
    - `\code{}` qui permet de mettre en forme du code sans utiliser le package complexe minted
    - `\wordcount` qui permet de compter le nombre de mots entre deux sections, très utile pour estimer la durée d'un oral
    - `\CopieInit` qui crée une présentation sommaire pour un document court, utilisé dans le projet S105.

J'ai également défini un environment `specialquote` pour faire des plus grandes citations

```latex
\begin{specialquote}{Rue, \textit{Euphoria}}
    That’s why I love reality TV - it’s funny, dramatic and I can focus on it. It’s pure, effortless entertainment
\end{specialquote}
```

## Liste des projets
- R102 : Mini projet autour de la création d'un EPUB, j'ai utilisé une quantité conséquente de scripts pour automatiser mon travail.
- S103 : Mise en place d'un serveur web sur un Raspberry Pi
- S104 : Création d'une base de données à partir de besoins clients
- S105 : Recueil de besoin et création d'un cahier des charges pour un site d'un éditeur de livres
- S106 : Création d'un site pour communiquer autour d'une solution d'authentification centralisé

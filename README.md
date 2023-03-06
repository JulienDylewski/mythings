# My Big Dick

## project structure

- assets : images, csv, font ...
- lib
    - l10n : fichiers de traduction
    - src : code de l'app
        - common : constants, templates, extensions de classe ...
          - common.dart : fichier à importer pour utiliser les variables l10n
        - model : modèles de données
        - components : widget réutilisables
        - pages : pages de l'application
            - les fichiers finissant par view sont des vue, ceux par view_model sont des 
            modèles de vue (voir MVVM)
        - service : services de l'application, utilisés dans les view model
            - backend : services communiquant avec les données, les services backend sont des singleton
            - frontend : services utilitaires pour le front (nécessitant le buildcontext donc pas des singleton)
            - notifier : Observables globaux, hors viewmodel (ex : AppGlobalState)
        - app.dart : page utilisé dans le runapp de main.dart
- main.dart : entry point
- pubspec.yaml : dépendances de l'app , la commande pub get permet de résoudre les dépendances et dénerer les fichiers d'internationalision avec lib/l10n


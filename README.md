# DigiBuzzer pour YunoHost

Paquet communautaire indépendant des sources amont pour déployer [DigiBuzzer](https://codeberg.org/ladigitale/digibuzzer) sur YunoHost.

## Compatibilité et architecture

- DigiBuzzer amont **0.8.6**, épinglé par SHA-256 dans `manifest.toml`.
- YunoHost 12.1.40 ou ultérieur ; Node.js 24 et Redis 7 sont fournis par les ressources YunoHost et Debian.
- Redis dédié à l'application, lié à `127.0.0.1`, protégé par un secret aléatoire et persistant dans le répertoire de données YunoHost.
- Les avatars envoyés par les utilisateurs sont stockés dans `$data_dir/avatars`, via le lien `avatars` dans le code amont ; ils sont inclus dans les sauvegardes.
- Nginx relaie les requêtes HTTP et WebSocket Socket.IO. `REVERSE_PROXY=0` laisse Express servir les fichiers générés par Vite/Vike.
- L'amont construit ses URL et redirige vers `/` sans prise en charge des préfixes de chemin : installer à la racine `/` d'un domaine dédié.

## Installation

Depuis le gestionnaire YunoHost, installer le paquet sur un domaine et choisir `/`. Le script refuse les sous-chemins. Node.js, les dépendances de compilation native (dont zlib), Redis, le service systemd et la configuration Nginx sont préparés automatiquement. La compilation nécessite environ 3 Go de RAM disponible et un accès réseau à npm.

La langue par défaut (`fr`) et le lien des mentions légales (vide) sont injectés au build. Les réglages Umami (`UMAMI_SCRIPT_URL`, `UMAMI_WEBSITE_ID`) sont facultatifs ; ils peuvent être renseignés dans `$data_dir/.env`, puis appliqués en redémarrant DigiBuzzer. Les variables `VITE_*` sont intégrées au bundle client et nécessitent une nouvelle compilation pour être modifiées.

## Sauvegardes et données

YunoHost sauvegarde le code, les données persistantes (avatars, Redis AOF/RDB et secrets) et les configurations Nginx/systemd. Le script sauvegarde Redis avant l'archivage et relance le service après l'opération si celui-ci était actif.

## Tests

La validation statique du paquet ne remplace pas un test d'installation réel. Tester l'installation, la mise à niveau, la sauvegarde/restauration, la suppression et les connexions Socket.IO sur une instance YunoHost 12.1.40 ou plus récente.

DigiBuzzer est distribué sous licence AGPL-3.0. Ce paquet YunoHost communautaire n'est pas affilié à La Digitale.

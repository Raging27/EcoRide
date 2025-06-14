# EcoRide

This is the EcoRide project – a platform for eco-friendly carpooling.

markdown
Copy
# EcoRide 🚗🌱

[![Ruby](https://img.shields.io/badge/Ruby-3.3.0-red)](https://ruby-lang.org)
[![Rails](https://img.shields.io/badge/Rails-8.0.1-red)](https://rubyonrails.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue)](https://www.postgresql.org)

Plateforme de covoiturage écologique avec gestion de trajets et crédits utilisateurs.

## 📋 Table des matières
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Base de données](#-base-de-données)
- [Démarrage](#-démarrage)
- [Bonnes pratiques Git](#-bonnes-pratiques-git)
- [Documentation](#-documentation)
- [Déploiement](#-déploiement)
- [Contribuer](#-contribuer)
- [Licence](#-licence)

## 🛠️ Prérequis
- Ruby 3.3.0
- Rails 8.0.1
- PostgreSQL 15
- Node.js 18+
- Yarn 1.22+

## 🚀 Installation
```bash
 Cloner le dépôt
git clone https://github.com/Raging27/EcoRide
cd EcoRide

# Installer les dépendances
bundle install
yarn install

# Configuration de la base de données
cp config/database.yml.example config/database.yml

# Créer et peupler la base de données
rails db:create
rails db:migrate
rails db:seed
📊 Base de données
Modèle conceptuel :
Diagramme MCD

Structure SQL disponible dans :

db/schema.rb (schéma ActiveRecord)

db/structure.sql (export PostgreSQL)

▶️ Démarrage
bash
Copy
# Démarrer le serveur
rails server
Accès : http://localhost:3000

🌿 Bonnes pratiques Git
Workflow Git Flow :

Copy
main      → Branche de production
develop   → Branche de développement
feature/* → Branches de fonctionnalités
Processus :

Créer une branche depuis develop :
git checkout -b feature/nouvelle-fonctionnalite

Faire des commits atomiques :
git commit -m "feat: ajout fonctionnalité X"

Ouvrir une Pull Request vers develop

Après validation CI/CD : merge dans develop

Déploiement en production via merge develop → main

📚 Documentation
Manuel d'utilisation

Charte graphique

Documentation technique

Kanban de projet
https://trello.com/b/M5A2TT9C/kanban-ecoride

🌍 Déploiement
🚨 Statut actuel :
Le déploiement sur Heroku est temporairement bloqué pour cause de problème d'accès au compte. L'application sera mise en ligne dès la résolution du problème par le support Heroku.

Environnement cible :

Hébergeur : Heroku

Version Ruby : 3.3.0

Base de données : PostgreSQL 15

🔑 Identifiants de test
Rôle	Email	Mot de passe
Admin	admin@example.com	Password123@
Employé	employee@example.com	Password123@
Conducteur	user1@example.com	Password123@
Passager	user2@example.com	Password123@
🤝 Contribuer
Forker le projet

Créer une branche (feature/ma-fonctionnalite)

Faire un commit des changements

Pusher vers la branche

Ouvrir une Pull Request


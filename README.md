# EcoRide

[![Ruby](https://img.shields.io/badge/Ruby-3.3.5-red)](https://ruby-lang.org)
[![Rails](https://img.shields.io/badge/Rails-8.0.1-red)](https://rubyonrails.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)](https://www.postgresql.org)

Plateforme de covoiturage écologique avec gestion de trajets et crédits utilisateurs.

## Table des matières
- [Démo en ligne](#-démo-en-ligne)
- [Prérequis](#prérequis)
- [Run with Docker](#run-with-docker)
- [Installation locale](#installation-locale)
- [Base de données](#base-de-données)
- [Démarrage](#démarrage)
- [Bonnes pratiques Git](#bonnes-pratiques-git)
- [Contribuer](#contribuer)
- [Licence](#licence)

## 🚀 Démo en ligne

**Application déployée :** https://ecoride-production-f1b6.up.railway.app/

### Comptes de démonstration

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| Administrateur | admin@example.com | Password123@ |
| Employé (modération) | employee@example.com | Password123@ |
| Conducteur | user1@example.com | Password123@ |
| Passager | user2@example.com | Password123@ |

## Prérequis

- Ruby 3.3.5
- Rails 8.0.1
- PostgreSQL 16
- MongoDB Atlas account (URI required)

## Run with Docker

```bash
# 1. Clone the repository
git clone https://github.com/Raging27/EcoRide
cd EcoRide

# 2. Create your local environment file
cp .env.example .env

# 3. Fill in the required secrets in .env:
#    RAILS_MASTER_KEY  — value from config/master.key (ask the project maintainer)
#    MONGODB_URI       — your MongoDB Atlas connection string

# 4. Build and start
docker compose up --build

# App is available at http://localhost:3000
```

The `web` container runs `db:prepare` on boot, so migrations are applied automatically.

## Installation locale

```bash
git clone https://github.com/Raging27/EcoRide
cd EcoRide

bundle install

rails db:create db:migrate db:seed
```

## Base de données

Ce projet utilise deux bases de données :

- **PostgreSQL** — données relationnelles (utilisateurs, trajets, réservations)
- **MongoDB Atlas** — données complémentaires via Mongoid

Schéma ActiveRecord disponible dans `db/schema.rb`.

## Démarrage

```bash
rails server
```

Accès : http://localhost:3000

## Bonnes pratiques Git

Workflow Git Flow :

```
main      → Branche de production
develop   → Branche de développement
feature/* → Branches de fonctionnalités
```

Processus :

1. Créer une branche depuis `develop` : `git checkout -b feature/nouvelle-fonctionnalite`
2. Faire des commits atomiques : `git commit -m "feat: ajout fonctionnalité X"`
3. Ouvrir une Pull Request vers `develop`
4. Après validation : merge dans `develop`, puis `develop` → `main` pour la production

## Contribuer

1. Forker le projet
2. Créer une branche (`feature/ma-fonctionnalite`)
3. Commiter les changements
4. Pusher vers la branche
5. Ouvrir une Pull Request

## Licence

Ce projet est sous licence MIT.

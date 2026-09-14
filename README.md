# EcoRide

[![Ruby](https://img.shields.io/badge/Ruby-3.3.5-red)](https://ruby-lang.org)
[![Rails](https://img.shields.io/badge/Rails-8.0.1-red)](https://rubyonrails.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)](https://www.postgresql.org)
[![Docker](https://img.shields.io/badge/Docker-ready-2496ED)](https://www.docker.com/)

**A deployed carpooling platform with driver, passenger, moderation, and administration workflows.**

EcoRide is a full-stack Rails application designed to encourage lower-impact travel. Users can publish and search trips, manage vehicles, book seats with platform credits, review completed journeys, and manage role-specific tasks from their dashboards.

**[Open the live application](https://ecoride-production-f1b6.up.railway.app/)**

## What the project demonstrates

- End-to-end Rails product development from domain model to production deployment
- Authentication, role-based access, account suspension, and moderation workflows
- Relational data in PostgreSQL plus MongoDB integration through Mongoid
- Reproducible local setup with Docker Compose
- Booking, credit, vehicle, trip-status, and review lifecycles
- Production deployment on Railway
- Security and code-quality tooling with Brakeman and RuboCop

## Main workflows

### Drivers

- Register vehicles and identify electric models
- Publish trips with route, schedule, price, and available seats
- Start and complete journeys
- Manage passenger bookings

### Passengers

- Search and filter available trips
- Book seats using platform credits
- Cancel bookings
- Review completed journeys

### Staff and administrators

- Approve or reject reviews
- Suspend or remove users
- Monitor platform activity through role-specific interfaces

## Architecture and stack

| Layer | Technology |
| --- | --- |
| Application | Ruby 3.3.5, Rails 8 |
| Relational data | PostgreSQL 16 and Active Record |
| Document data | MongoDB Atlas and Mongoid |
| Authentication | Devise |
| Frontend | Hotwire, Turbo, Stimulus, HTML, CSS |
| Reporting | Chartkick and Groupdate |
| Quality | Brakeman, RuboCop, Rails tests |
| Delivery | Docker Compose and Railway |

PostgreSQL stores core relational records such as users, vehicles, trips, and passenger bookings. MongoDB/Mongoid supports complementary document-oriented data.

## Demo accounts

| Role | Email | Password |
| --- | --- | --- |
| Administrator | `admin@example.com` | `Password123@` |
| Moderator | `employee@example.com` | `Password123@` |
| Driver | `user1@example.com` | `Password123@` |
| Passenger | `user2@example.com` | `Password123@` |

These credentials are for demonstration data only.

## Run with Docker

### Requirements

- Docker and Docker Compose
- A MongoDB Atlas connection string
- The Rails master key supplied by the project maintainer

```bash
git clone https://github.com/Raging27/EcoRide.git
cd EcoRide
cp .env.example .env
```

Add the required values to `.env`:

```dotenv
RAILS_MASTER_KEY=your_key
MONGODB_URI=your_mongodb_atlas_uri
```

Then start the application:

```bash
docker compose up --build
```

The application will be available at `http://localhost:3000`. The web container runs `db:prepare` on startup.

## Run without Docker

### Requirements

- Ruby 3.3.5
- Rails 8
- PostgreSQL 16
- MongoDB Atlas

```bash
git clone https://github.com/Raging27/EcoRide.git
cd EcoRide
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

## Repository workflow

- `main`: production-ready code
- `develop`: integration branch
- `feature/*`: isolated feature work

Changes are developed on feature branches and merged through pull requests.

## License

MIT

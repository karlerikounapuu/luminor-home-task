# CMDB - Configuration Management Database

A Rails-based Configuration Management Database (CMDB) system for tracking configuration items and their relationships.

## Technology Stack

- Ruby 3.4.7
- Rails 8.1.1
- PostgreSQL
- ActiveAdmin 4.0.0 with Tailwind CSS
- Devise/CanCanCan for authentication/authorization

## Features

### Circular Dependency Prevention
The system prevents circular dependencies at the model level:
- Direct cycles (A → B → A)
- Indirect cycles (A → B → C → A)
- Self-references (A → A)

### Deletion Protection
Configuration items with dependents cannot be deleted. The system will show an error message listing all dependent items.

### Relationship Management
- Same configuration items can have multiple relationships with different types
- Relationships are managed from the configuration item detail page

## Quick Start with Docker

### Prerequisites
- Docker
- Docker Compose

### Run the application

```bash
# Start all services (web + database)
docker-compose up

# The application will be available at http://localhost:3000
```

### Seed the database

Database should be pre-seeded by db setup inside of docker-compose.yml, but in case it isn't: 

```bash
# Run migrations and seed data
docker-compose exec web bin/rails db:migrate db:seed
```

This creates:
- **Item Statuses**: Active, Retired, Maintenance
- **Item Types**: Server, Application, Database
- **Environments**: Production, Staging, Development
- **Relationship Types**: depends_on, runs_on, uses, connects_to
- **Users** (development only):
  - Admin: admin@example.com / password
  - Viewer: viewer@example.com / password

## Running Tests

### Run all tests with Docker

First prepare the test database
```bash
docker-compose exec web env RAILS_ENV=test bin/rails db:test:prepare
```

and then

```bash
docker-compose exec web bin/rails test
```

## Admin interface

Access the admin interface at http://localhost:3000/admin

### Default Users

**Admin User**
- Email: admin@example.com
- Password: password
- Permissions: Full access

**Viewer User**
- Email: viewer@example.com
- Password: password
- Permissions: Read-only access

### Managing Configuration Items

1. Navigate to "Configuration Items" in the admin menu
2. Click "New Configuration Item" to create
3. View item details to see dependencies and dependents
4. Add relationships from the item detail page

## API Documentation

The API uses HTTP Basic Authentication. All endpoints require authentication with ActiveAdmin account (details above)

### Base URL
```
http://localhost:3000/api/v1
```

### Authentication
Include HTTP Basic Auth credentials in the Authorization header:
```bash
curl -u "email:password" http://localhost:3000/api/v1/configuration_items
```

### Endpoints

#### List Configuration Items
```bash
GET /api/v1/configuration_items
```

**Optional Query Parameters:**
- `item_type` - Filter by item type name
- `item_status` - Filter by item status name

**Example:**
```bash
curl -u "admin@example.com:password" \
  "http://localhost:3000/api/v1/configuration_items?item_type=server&item_status=active"
```

**Response:**
```json
[
  {
    "id": "uuid",
    "name": "Web Server",
    "description": "Main web server",
    "item_type": "Server",
    "item_status": "Active",
    "item_environment": "Production",
    "created_at": "2025-11-13T00:00:00.000Z",
    "updated_at": "2025-11-13T00:00:00.000Z"
  }
]
```

#### Get Configuration Item Details
```bash
GET /api/v1/configuration_items/:id
```

**Example:**
```bash
curl -u "admin@example.com:password" \
  http://localhost:3000/api/v1/configuration_items/:id
```

**Response:**
```json
{
  "id": "uuid",
  "name": "Web Server",
  "description": "Main web server",
  "item_type": "Server",
  "item_status": "Active",
  "item_environment": "Production",
  "created_at": "2025-11-13T00:00:00.000Z",
  "updated_at": "2025-11-13T00:00:00.000Z",
  "dependencies": [
    {
      "id": "relationship-uuid",
      "relationship_type": "depends_on",
      "configuration_item": {
        "id": "item-uuid",
        "name": "Database Server"
      }
    }
  ],
  "dependents": [
    {
      "id": "relationship-uuid",
      "relationship_type": "runs_on",
      "configuration_item": {
        "id": "item-uuid",
        "name": "Application Server"
      }
    }
  ]
}
```

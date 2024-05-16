# Prosas challenge

This is a project to calc grades of projects.
These are the requirements for the project:
- One endpoint to create or update projects.
- One endpoint to return projects with pagination from 25 to 100 objects per page. I choose 25 for this project.
- One endpoint to create or update criterias.
- When a criteria is updated the application should recalculate the weighted_means and the average for the projects.
- When a grade is updated the application should recalculate the weighted_means and the average for the projects.

### How to run in development

First, up the dependencies services:

```bash
make dependencies.start.dev
```

Inside project directory do:

- bundle install
- RAILS_ENV=development bundle e rails db:create
- RAILS_ENV=development bundle e rails db:migrate
- RAILS_ENV=development bundle e rails s

### How to run tests

First, up the dependencies services:

```bash
make dependencies.start.test
```

Then inside backend project directory do:

- bundle install
- RAILS_ENV=test bundle e rails db:create
- RAILS_ENV=test rails db:migrate
- bundle e rspec

### To run Lints for this project

- make rubocop

### Api

POST /projects: /api/v1/projects
```json
{
    "name": "p13",
    "assessments": [
        {
            "id": 24,
            "grades": [
                {
                    "grade": 10,
                    "criteria": {
                        "id": 28,
                        "weight": 30
                    }                    
                },
                {
                    "grade": 8,
                    "criteria": {
                        "id": 28,
                        "weight": 1.5
                    }                    
                }
            ]
        }
    ]
}
```

---

GET /projects: /api/v1/projects
or
GET /projects: /api/v1/projects?page={x}

---

POST /criterias: /api/v1/criterias
```json
{
    "id": 1,
    "weight": 20
}
```

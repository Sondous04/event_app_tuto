# Event RSVP – AWS Web Application

A serverless web application to manage event registrations. Events are stored in **Amazon RDS (MySQL)** and RSVP responses in **Amazon DynamoDB**, exposed through a REST API built with **API Gateway** and **AWS Lambda**, with a static frontend served by **S3 + CloudFront**.

## Architecture

```
User ──► CloudFront ──► S3 (static frontend: index.html, style.css)
                │
                └──► API Gateway ──► Lambda (Node.js)
                                        ├──► RDS MySQL      (events)
                                        └──► DynamoDB       (RSVP responses)

IAM: roles and permissions for Lambda
AWS Budgets: cost alert
```

## Tech stack

- **AWS**: S3, CloudFront, API Gateway, Lambda, RDS (MySQL), DynamoDB, IAM, AWS Budgets
- **Node.js** with `mysql2`, `@aws-sdk/client-dynamodb` and `dotenv`
- **Docker** (AWS Lambda Node.js 20 base image)
- **Git / GitHub**
- **Postman** and **DBeaver** for API and database testing

## Project structure

```
event-rsvp-tuto/
├── index.js          # Lambda handler (entry point)
├── app.js            # Application logic
├── events.js         # Event routes / MySQL queries
├── utils.js          # Helper functions
├── index.html        # Frontend page
├── style.css         # Frontend styles
├── package.json
├── package-lock.json
├── Dockerfile        # Lambda container image
├── .dockerignore
├── .env.example      # Template of required environment variables
└── .gitignore
```

## Getting started

### Prerequisites

- Node.js 20+
- Docker Desktop
- An AWS account with an RDS MySQL instance and a DynamoDB table

### 1. Clone and install

```bash
git clone https://github.com/YOUR_USERNAME/event-rsvp-tuto.git
cd event-rsvp-tuto
npm install
```

### 2. Configure environment variables

Copy `.env.example` to `.env` and fill in your values:

```
DB_HOST=your-db.xxxxxxxx.eu-west-3.rds.amazonaws.com
DB_NAME=your_database_name
DB_PASS=your_password
DB_USER=admin
REGION=eu-west-3
```

| Variable | Description |
|---|---|
| `DB_HOST` | RDS MySQL endpoint |
| `DB_NAME` | Database name |
| `DB_USER` | Database user |
| `DB_PASS` | Database password |
| `REGION` | AWS region (e.g. `eu-west-3`) |

> The `.env` file is listed in `.gitignore` and must **never** be committed.
> On AWS Lambda, set the same variables under **Configuration → Environment variables**.

## Run with Docker

The backend is packaged as an AWS Lambda container image, so it runs locally the same way it runs on AWS.

**Build the image:**

```bash
docker build -t event-rsvp-tuto .
```

**Run the container:**

```bash
docker run -p 9000:8080 --env-file .env event-rsvp-tuto
```

**Send a test event** (in a second terminal):

```bash
curl -X POST "http://localhost:9000/2015-03-31/functions/function/invocations" -d "{}"
```

PowerShell equivalent:

```powershell
Invoke-WebRequest -Method POST -Uri "http://localhost:9000/2015-03-31/functions/function/invocations" -Body "{}"
```

To test a specific route, send an API Gateway-style event, for example:

```json
{"httpMethod": "GET", "path": "/events"}
```

> For DynamoDB access from a local container, add `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to your `.env`. Never commit them.

## Deployment on AWS (overview)

1. Create the **RDS MySQL** database and the **DynamoDB** table.
2. Deploy the backend code to **Lambda** and set its environment variables.
3. Create the **API Gateway** routes and connect them to the Lambda function.
4. Upload `index.html` and `style.css` to an **S3** bucket and serve them through **CloudFront**.
5. Attach the right **IAM** permissions to the Lambda role (DynamoDB access, VPC access to RDS).
6. Set up an **AWS Budget** alert to monitor costs.

## Security notes

- Credentials are read from environment variables, never hard-coded.
- `.env` is excluded from Git and from the Docker build context.
- The RDS security group should only allow the connections that are needed.

## What I learned

- Deploying a multi-service serverless architecture on AWS
- Adapting existing code and Lambda handlers to match deployed API routes
- Combining a relational database (events) with a NoSQL store (RSVPs)
- Managing secrets with environment variables
- Containerizing a Lambda function with Docker and testing it locally
- Monitoring cloud costs with AWS Budgets

## Author

Your Name – [GitHub](https://github.com/YOUR_USERNAME) · [LinkedIn](https://www.linkedin.com/in/YOUR_PROFILE)

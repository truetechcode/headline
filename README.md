# Headlines Web Application

The Headlines web application allows users to view and save top news headlines for a chosen country. It utilizes the NewsApi to fetch the latest news data. The application supports both HTML and JSON distribution, and provides API endpoints for user registration, authentication, and managing saved articles.

## Prerequisites

Make sure you have the following software installed on your development machine:

- Docker
- Ruby (version 3.2.1)
- Ruby on Rails (version 7.0.4)

## Getting Started

Follow the steps below to set up the development environment and run the Headlines application.

1. Clone the repository:

```shell
git clone https://github.com/truetechcode/headline.git
```

2. Navigate to the project directory:

```shell
cd headlines
```

3. Update the environment variables:

Rename the `.env.dev` file to `.env` and replace the placeholder values with your actual environment variables:

```
# Get an API KEY for NEWSAPI from https://newsapi.org/account

NEWSAPI_KEY=sample_1234567890

DB_HOST=db
DB_PORT=5432
DB_NAME=headline_production
DB_USERNAME=headline
DB_PASSWORD=headline
```

4. Build and run the Docker containers:

```shell
docker-compose up --build
```

5. Run migrations:

```shell
docker-compose run web bundle exec rails db:migrate
```

6. Start the Rails server:

```shell
docker-compose up
```

7. Access the application:

Open a web browser and visit `http://localhost:3000` to access the Headlines application.

## API Endpoints

The Headlines application provides the following API endpoints for user registration, authentication, and managing articles:

### User Registration

- **Endpoint**: `POST /api/users`
- **Payload**: JSON
- **Sample Payload**:

```json
{
  "user": {
    "name": "Test Example",
    "email": "test@example.com",
    "password": "password",
    "country_code": "US"
  }
}
```

### User Sign-in

- **Endpoint**: `POST /api/sessions`
- **Payload**: JSON
- **Sample Payload**:

```json
{
  "session": {
    "email": "test@example.com",
    "password": "password"
  }
}
```

### User Sign-out

- **Endpoint**: `DELETE /api/sessions/:id`

### Get All Headlines

- **Endpoint**: `GET /api/articles`

### Save New Headline

- **Endpoint**: `POST /api/articles`
- **Payload**: JSON
- **Sample Payload**:

```json
{
  "article": {
    "source": "ABC News",
    "author": "Aaron Katersky",
    "title": "Judge sets January 2024 trial date for Sample News - ABC News",
    "description": "Judge sets January 2024 trial date for Sample News.",
    "url": "https://abcnews.go.com/US/judge-sets-january-2024-trial-date-jean-carrolls/story?id=100123378",
    "url_to_image": "https://s.abcnews.com/images/Politics/sample_news_image_16x9_992.jpg",
    "publish_at": "2023-06-16T04:20:39Z",
    "content": "A judge has set an early 2024 trial date for sample"
  }
}
```

### Delete Saved Headline

- **Endpoint**: `DELETE /api/articles/:id`

## TODO

1. Implement Stimulus.js for Responsive Interactions:
   - Integrate Stimulus.js into the Headlines application.
   - Update the country select functionality to use Stimulus.js for a more responsive and dynamic user experience.
   - Enhance the save and delete actions for headlines using Stimulus.js to perform the operations in-place without page refresh.

2. Background Job for NewsApi Call:
   - Move the NewsApi call to a background job to offload the processing from the main request-response cycle.
   - Configure the background job to run periodically or on-demand to update the headlines data from the NewsApi.

3. Replace has_secure_password with Devise for Authentication:
   - Integrate Devise gem into the Headlines application.
   - Implement token based API authentication strategy.

4. CI/CD Pipeline:
   - Set up a Continuous Integration and Continuous Deployment (CI/CD) pipeline for the Headlines application.

5. Additional Enhancements:
   - Implement pagination or infinite scrolling for the headlines index page to improve performance and user experience.
   - Implement caching strategies to optimize API requests and improve overall application performance.

## Contributing

If you want to contribute to the Headlines application, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Push your changes to your forked repository.
5. Submit a pull request to the main repository.

## License

The Headlines application is open-source and released under the [MIT License](https://opensource.org/licenses/MIT).

---

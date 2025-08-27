# NovaUser

NovaUser is a RESTful API built with Elixir and Phoenix Framework in an umbrella project architecture. It manages users, roles, and businesses, providing powerful filtering, sorting, and pagination features via clean JSON endpoints.

🔧 Features

🧑 User Management – Create, update, delete, and view users

🏷️ Role Integration – Associate roles with users (e.g., admin, user, manager)

🏢 Business Linking – Assign users to businesses

🔍 Filtering & Sorting – Filter users by name, email, role, business, and sort by name

📄 Pagination – Paginated responses using Scrivener

🧩 Swagger Support – API documentation using phoenix_swagger

📚 Tech Stack

Elixir + Phoenix (1.8)

PostgreSQL (via Ecto)

Scrivener for pagination

Swagger for API documentation

JSON rendering via Phoenix views

🚀 Getting Started
# Set up dependencies
mix deps.get

# Create and migrate the database
mix ecto.create

mix ecto.migrate

# Run the server
mix phx.server

📘 API Docs

Swagger docs available at:
http://localhost:4000/api/swagger

📁 Umbrella Structure

apps/data – Contexts, schemas, and DB logic

apps/api – Phoenix web layer: controllers, routes, views, Swagger



Swagger based backend endpoint app for implementation of APIs for user data. It is  basically based on handling user details along with user business details and user role details
 


**~~~~~~~~~~~~~~~~~~~~Here is attached the run time look and feel of project::**~~~~~~~~~~~~~~~~~~~~




# NovaUser

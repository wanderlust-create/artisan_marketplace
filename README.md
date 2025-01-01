# Artisan Marketplace

This project serves as a marketplace for artisans and administrators to manage users, products, and events. The platform includes role-based permissions, enabling super admins to manage regular admins and other entities. Built with Ruby on Rails.

---

## 📝 Table of Contents

- [Features](#features)
- [Setup](#setup)
- [Folder Structure](#folder-structure)
- [Schema](#schema)
- [Contributor](#contributor)

---

## ✨ Features <a name="features"></a>

### Admin Features:
- **Super Admins**:
  - Create, edit, and delete admin accounts.
  - Manage role-based permissions for regular admins.
- **Regular Admins**:
  - Manage artisan accounts.
  - Create and manage products associated with artisans.

### Artisan Features:
- Create and manage product listings.

### General Features:
- Authentication for admins and artisans.
- Role-based access control.
- Responsive UI for easy navigation.

---

## 💻 Setup <a name="setup"></a>

### Requirements:
- [Ruby 3.1.0](https://www.ruby-lang.org/)
- [Rails 7.0](https://rubyonrails.org/)
- [PostgreSQL](https://www.postgresql.org/)

### Installation:
1. Clone the repository:  
   ```bash
   git@github.com:wanderlust-create/artisan-marketplace.git
   ```
2. Navigate to the project directory:  
   ```bash
   cd artisan-marketplace
   ```
3. Install gems:  
   ```bash
   bundle install
   ```
4. Set up the database:  
   ```bash
   rails db:create db:migrate db:seed
   ```
5. Start the Rails server:  
   ```bash
   rails server
   ```
6. Access the application in your browser:  
   `http://localhost:3000`

---

## 📂 Folder Structure <a name="folder-structure"></a>

- `app/controllers`: Handles HTTP requests for admins, artisans, and sessions.
- `app/models`: Contains models for `Admin`, `Artisan`, and other database entities.
- `app/views`: Renders HTML for user and admin interfaces.
- `config/routes.rb`: Defines application routes, including role-based access paths.
- `db/migrate`: Database schema and migration files.

---

## 🗟 Schema <a name="schema"></a>

### Simplified Schema:

- **Admins**:
  - Attributes: `id`, `email`, `password_digest`, `role` (enum: 0 = regular, 1 = super_admin), `created_at`, `updated_at`.

- **Artisans**:
  - Attributes: `id`, `store_name`, `email`, `password_digest`, `admin_id` (FK to Admins), `created_at`, `updated_at`.

- **Customers**:
  - Attributes: `id`, `first_name`, `last_name`, `email`, `created_at`, `updated_at`.

- **Products**:
  - Attributes: `id`, `name`, `description`, `price`, `stock`, `artisan_id` (FK to Artisans), `created_at`, `updated_at`.

- **Invoices**:
  - Attributes: `id`, `customer_id` (FK to Customers), `status` (enum: 0 = pending, 1 = completed, 2 = cancelled), `created_at`, `updated_at`.

- **InvoiceItems**:
  - Attributes: `id`, `invoice_id` (FK to Invoices), `product_id` (FK to Products), `quantity`, `unit_price`, `status` (enum: 0 = pending, 1 = shipped, 2 = cancelled), `created_at`, `updated_at`.

- **Reviews**:
  - Attributes: `id`, `rating`, `text`, `product_id` (FK to Products), `customer_id` (FK to Customers), `created_at`, `updated_at`.

- **Transactions**:
  - Attributes: `id`, `invoice_id` (FK to Invoices), `credit_card_number`, `credit_card_expiration_date`, `status` (enum: 0 = approved, 1 = declined, 2 = refunded), `created_at`, `updated_at`.

### Visual Representation:

![Database Schema](https://github.com/wanderlust-create/artisan_marketplace/blob/main/app/assets/images/artisan_marketplace_schema.png?raw=true)

More detailed schema design can be added in future updates.

---

## Contributor <a name="contributor"></a>
👩🏽‍🎤 Tamara Dowis | [GitHub](https://github.com/wanderlust-create) | [LinkedIn](https://www.linkedin.com/in/tamara-dowis/)


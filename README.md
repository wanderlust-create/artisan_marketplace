
# Artisan Marketplace

This project serves as a marketplace for artisans and administrators to manage users and products. The platform includes role-based permissions, artisan discount management, and a public JSON API. Built with Ruby on Rails.

> **Note**: This is Tamara's first project built with the assistance of AI tools, showcasing her growth as a developer and collaboration with AI.

---

## 📝 Table of Contents

- [Features](#features)
- [Setup](#setup)
- [Folder Structure](#folder-structure)
- [Schema](#schema)
- [Stretch Goals](#stretch-goals)
- [Contributors](#contributors)

---

## ✨ Features

### Admin Features:
- **Super Admins**:
  - Create, edit, and delete admin accounts.
  - Assign or change roles for regular admins.
- **Regular Admins**:
  - Manage artisan accounts.
  - View and manage products tied to artisans.

### Artisan Features:
- Create, edit, and delete products.
- Create discounts on products using either a **fixed discount price** or a **percentage reduction**.
- Discounts are validated to ensure:
  - Only one input (price or percentage) is required.
  - The discount does not exceed the original product price.
  - Discount periods do not overlap.

### General Features:
- Authentication and role-based access.
- Responsive admin and artisan dashboards.
- Clean MVC architecture with pagination and caching.

---

## 🧠 New Features

### ✅ Discount Analytics Scope
```ruby
Product.with_active_discounts
```
Returns all products with currently active discounts (based on today's date). Useful for:
- Admin dashboards
- Seasonal campaigns
- Surfacing trending sales

### ✅ Public Discounts JSON API

**Endpoint:**  
`GET /api/v1/products/:product_id/discounts`

**Returns:** JSON array of discounts sorted by start date.

**Example Response:**
```json
[
  {
    "id": 1,
    "original_price": "50.00",
    "discount_price": "45.00",
    "percentage_off": null,
    "start_date": "2025-04-01",
    "end_date": "2025-04-10",
    "discount_type": "price"
  }
]
```

---

## 💻 Setup

### Requirements:
- Ruby `3.3.6`
- Rails `~> 7.0.8`
- SQLite (dev/test) or PostgreSQL (for production)

### Instructions:
```bash
git clone git@github.com:wanderlust-create/artisan-marketplace.git
cd artisan-marketplace
bundle install
rails db:create db:migrate db:seed
rails server
```

Access locally at:  
`http://localhost:3000`

---

## 📂 Folder Structure

- `app/controllers` – Admin, Artisan, API, and Auth logic.
- `app/models` – Business logic for Users, Products, Discounts, etc.
- `app/serializers` – JSON serialization for API responses.
- `config/routes.rb` – Nested resourceful routing, namespaced APIs.
- `spec/` – RSpec test suite with model, feature, and request specs.

---

## 🗟 Schema

View:  
![Schema Image](https://github.com/wanderlust-create/artisan_marketplace/blob/main/app/assets/images/artisan_marketplace_schema.png?raw=true)

Entities:
- **Admins** – role-based authorization (`regular`, `super_admin`)
- **Artisans** – store owners tied to an admin
- **Products** – owned by artisans, include stock & visibility
- **Discounts** – attached to products, supports fixed or % reductions
- **Customers** – future-ready for order and review features
- **Invoices**, **InvoiceItems**, **Transactions** – schema defined for future sales system
- **Reviews** – allow customers to rate products (planned)

---

## 🎯 Stretch Goals (In Progress or Future Work)

- [ ] Customer order flow (invoices, invoice items, transactions)
- [ ] Product reviews and average rating
- [ ] Admin dashboard analytics (top artisans, popular discounts)
- [ ] OAuth or 2FA authentication
- [ ] Background jobs for auto-expiring discounts

---

## 👩🏽‍💻 Contributors

- Tamara Dowis | [GitHub](https://github.com/wanderlust-create) | [LinkedIn](https://www.linkedin.com/in/tamara-dowis/)
- 🤖 ChatGPT AI (dev pair + code assistant)

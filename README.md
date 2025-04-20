<p align="center">
  <img src="./assets/artisan-marketplace-banner.png" alt="SArtisan Marketplace Banner" width=800"/>
</p>
<p align="center"><em>A role-based marketplace where artisans and admins can manage handmade products and discounts.</em></p>

# Artisan Marketplace

Artisan Marketplace is a backend Rails application built to manage artisan-made products, users, and discounts. The platform features role-based permissions for admins and artisans, discount logic, a JSON API with authentication for protected endpoints, and test coverage in progress (~59%).

> **Note**: Note: This is Tamara's first project built with the support of AI tools, highlighting her growth and adaptability as a developer.
>
> 
<p align="center">
  <img src="https://img.shields.io/badge/Ruby-CC342D?style=flat-square&logo=ruby&logoColor=white"/>
  <img src="https://img.shields.io/badge/Rails-5C0303?style=flat-square&logo=rubyonrails&logoColor=white"/>
  <img src="https://img.shields.io/badge/Tested_with-RSpec-701516?style=flat-square&logo=rubyonrails&logoColor=white"/>
  <img src="https://img.shields.io/badge/coverage-59%25-yellow?style=flat-square"/>
  <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square"/>
  <img src="https://img.shields.io/badge/Made_with-%E2%98%95-blue?style=flat-square"/>
  <img src="https://img.shields.io/badge/Made_with-%F0%9F%92%96-purple?style=flat-square"/>
</p>

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

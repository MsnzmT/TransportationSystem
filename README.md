# Transportation System (RAW SQL Project)

This project is a **RAW SQL implementation** of a transportation system, covering all essential database components such as:

- **DDL (Data Definition Language):** Table structures and constraints.
- **Functions:** User authentication, ID retrieval, and role validation.
- **Procedures:** Activating users, changing ticket status, and rating travels.
- **Triggers:** Automatic data insertion based on user roles.
- **Queries:** Filtering tickets, retrieving stats, and generating reports.

## Files and Features
- **`user.sql`** – User authentication, account activation, and role-based data insertion.
- **`supportSystem.sql`** – Similar to `user.sql`, handling users and authentication.
- **`passenger.sql`** – Passenger panel, ticket reservation, and travel rating.
- **`manager.sql`** – Manager functions, top customers, income reports, and travel statistics.

## Key Functionalities
- Secure **user login** with password encryption.
- **Automated role-based inserts** using triggers.
- **Ticket reservation & payment processing** with capacity validation.
- **Statistical insights** for managers, including top customers, bestselling travels, and revenue reports.

## Usage
- Load the SQL scripts into your **PostgreSQL** database.
- Run queries to manage users, book travels, and retrieve insights.

This project serves as a **complete database foundation** for a transportation system using only **RAW SQL**. 🚀

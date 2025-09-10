create database BookStore;

use BookStore;

CREATE TABLE Books (
book_id integer primary key,
title TEXT,
genre TEXT,
price DECIMAL(6, 2),
stock INTEGER
);

CREATE TABLE CUSTOMERS (
customer_id INTEGER PRIMARY KEY,
    name TEXT,
    city TEXT,
    signup_date DATE
);

CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    book_id INTEGER,
    quantity INTEGER,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

CREATE TABLE MarketingSpend (
    spend_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    spend_amount DECIMAL(7,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

show databases;





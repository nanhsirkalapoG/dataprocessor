# Testing

## User

### Create User
```bash
curl --location --request POST 'http://localhost:3000/users' \
--header 'Content-Type: application/json' \
--data-raw '{
    "first_name": "Magnus",
    "last_name": "Carlsen",
    "email": "magnus.c2@chess.com"
}'
```

### Get All Users
```bash
curl --location --request GET 'http://localhost:3000/users'
```

## Products

### Create Product
```bash
curl --location --request POST 'http://localhost:3000/products' \
--header 'Content-Type: application/json' \
--data-raw '{
    "title": "Jeans",
    "description": "Pant",
    "user_id": 2,
    "external_id": "external_id_1",
    "price": 10.45
}'
```

### Get All Products
```bash
curl --location --request GET 'http://localhost:3000/products'
```

### Add/Update Custom Fields
```bash
curl --location --request PATCH 'http://localhost:3000/products/2' \
--header 'Content-Type: application/json' \
--data-raw '{
    "price": 10.75,
    "custom_fields": [{
        "field_name": "size1",
        "value": 24,
        "data_type": "number"
    },
    {
        "field_name": "size2",
        "value": 28,
        "data_type": "number"
    }]
}'
```

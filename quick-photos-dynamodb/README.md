# Folders
- application: The application directory contains example code for reading and writing data in your table. This code is similar to code you would have in your real mobile application backend.
- scripts: The scripts directory contains administrator-level scripts, such as for creating your table, adding a secondary index, or deleting your table.

# Flow

## User profile access patterns
- Create user profile (write)
- Update user profile (Write)
- Get user profile (read)

## Photo access pattern
- Upload photo for user (write)
- View recent photos for user (read)
- React to a photo (write)
- View photo and reactions (read)

## Friendship access patterns
- Follow (user)
- View followers for user (read)
- View followed for user (read)

# Database

| Entity | Hash | Range |
| -- | -- | -- |
| User | USER#<USERNAME> | #METADATA#<USERNAME> |
| Photo | USER#<USERNAME> | PHOTO#<USERNAME>#<TIMESTAMP> |
| Reaction | REACTION#<USERNAME>#<TYPE> | PHOTO#<USERNAME>#<TIMESTAMP> |
| Friendship | USER#<USERNAME> | #FRIEND#<FRIEND_USERNAME> |

For the User entity, the HASH value will be USER#<USERNAME>.
We're using a prefix to identify the entity and prevent any possible collisions accross entity types.

The photo entity is a child entity of a particular User entity. For the RANGE key, use PHOTO#<USERNAME>#<TIMESTAMP> to uniquely identify a photo in your table.

The Reaction entity is a child entity of a particular photo entity. There is a one-to-many relationship to the Photo entity. The *RANGE* key for a Reaction entity is the same pattern as the *RANGE* key for a Photo entity.

# Run

```python
python scripts/create_table.py
python scripts/bulk_load_table.py
python scripts/add_inverted_index.py
```
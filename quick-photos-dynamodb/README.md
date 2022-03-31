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

```bash
python scripts/create_table.py
python scripts/bulk_load_table.py
python scripts/add_inverted_index.py
```

# fetch_user_and_photos.py
This example is written for the following access patterns.
- Get user profile (read)
- View recent photos for user (read)

```bash
python application/fetch_user_and_photos.py
```

Output
```
User<jacksonjason -- John Perry>
Photo<jacksonjason -- 2018-05-30T15:42:38>
Photo<jacksonjason -- 2018-06-09T13:49:13>
Photo<jacksonjason -- 2018-06-26T03:59:33>
Photo<jacksonjason -- 2018-07-14T10:21:01>
Photo<jacksonjason -- 2018-10-06T22:29:39>
Photo<jacksonjason -- 2018-11-13T08:23:00>
Photo<jacksonjason -- 2018-11-18T15:37:05>
Photo<jacksonjason -- 2018-11-26T22:27:44>
Photo<jacksonjason -- 2019-01-02T05:09:04>
Photo<jacksonjason -- 2019-01-23T12:43:33>
Photo<jacksonjason -- 2019-03-03T02:00:01>
Photo<jacksonjason -- 2019-03-03T18:20:10>
Photo<jacksonjason -- 2019-03-11T15:18:22>
Photo<jacksonjason -- 2019-03-30T02:28:42>
Photo<jacksonjason -- 2019-04-14T21:52:36>
```
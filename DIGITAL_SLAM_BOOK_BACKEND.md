# Digital SLAM Book --- Backend Implementation Specification

## 1. Purpose

Build the complete Java Spring Boot REST backend for the Digital SLAM
Book.

The backend is responsible for:

-   Creating SLAM Books
-   Retrieving SLAM Books
-   Updating SLAM Books
-   Deleting SLAM Books
-   Managing friend contributions
-   Validating input
-   Persisting application data in PostgreSQL
-   Managing image references
-   Supporting Supabase Storage integration
-   Returning frontend-friendly REST responses
-   Supporting production CORS
-   Supporting deployment on Render

## 2. Required Technology

Use:

-   Java
-   Spring Boot
-   Spring Web
-   Spring Data JPA
-   Hibernate
-   PostgreSQL
-   Maven
-   REST APIs
-   Bean Validation
-   Postman for API testing

Infrastructure:

-   PostgreSQL hosted by Supabase
-   Images stored in Supabase Storage
-   Backend deployed on Render

Recommended architecture:

``` text
Controller
    ↓
Service
    ↓
Repository
    ↓
PostgreSQL
```

## 3. Suggested Package Structure

``` text
src/main/java/com/example/slambook/
├── controller/
│   ├── SlamBookController
│   └── FriendController
├── service/
│   ├── SlamBookService
│   └── FriendService
├── repository/
│   ├── SlamBookRepository
│   └── FriendRepository
├── entity/
│   ├── SlamBook
│   └── Friend
├── dto/
│   ├── CreateSlamBookRequest
│   ├── UpdateSlamBookRequest
│   ├── SlamBookResponse
│   ├── CreateFriendRequest
│   ├── UpdateFriendRequest
│   └── FriendResponse
├── exception/
│   ├── ResourceNotFoundException
│   └── GlobalExceptionHandler
├── config/
│   └── CorsConfig
└── service/impl/
```

The FRD explicitly requires the Controller → Service → Repository →
PostgreSQL flow. The package structure above is an implementation
recommendation.

## 4. Main Entity: SlamBook

The FRD suggests a primary `slam_book` table with:

``` text
id
full_name
nickname
profile_photo_url
date_of_birth
gender
favorite_color
hobbies
about_me
friendship_rating
is_best_friend
friendship_start_date
song_name
song_artist
song_url
song_dedication
memory_photo_url
memory_text
created_at
updated_at
```

Use a generated primary key.

Suggested Java representation:

``` java
Long id;
String fullName;
String nickname;
String profilePhotoUrl;
LocalDate dateOfBirth;
Gender gender;
String favoriteColor;
List<String> hobbies;
String aboutMe;
Integer friendshipRating;
Boolean isBestFriend;
LocalDate friendshipStartDate;
String songName;
String songArtist;
String songUrl;
String songDedication;
String memoryPhotoUrl;
String memoryText;
LocalDateTime createdAt;
LocalDateTime updatedAt;
```

The exact identifier type and hobby persistence strategy should be
finalized during implementation.

## 5. Gender

The FRD defines:

-   Male
-   Female
-   Other

Use an enum in Java:

``` java
public enum Gender {
    MALE,
    FEMALE,
    OTHER
}
```

Persist it using an appropriate JPA enum mapping.

## 6. Friend Entity

The FRD requires friend contributions but does not prescribe a complete
database schema.

Friend information may include:

``` text
friend name
relationship
friendship rating
best friend status
friendship since
message
song dedication
memory photo
memory
```

A suggested relationship is:

``` text
SlamBook 1 ──────── * Friend
```

Each Friend belongs to exactly one SLAM Book.

Suggested fields:

``` text
id
slam_book_id
friend_name
relationship
friendship_rating
is_best_friend
friendship_since
message
song_name
song_artist
song_url
song_dedication
memory_photo_url
memory_text
created_at
updated_at
```

This is a recommended backend design because the FRD specifies friend
CRUD and association with the corresponding SLAM Book, but it does not
provide an exact friend table definition.

## 7. Database Relationship

Conceptually:

``` text
slam_book
   |
   | 1
   |
   | *
   ↓
friend
```

Foreign key:

``` text
friend.slam_book_id → slam_book.id
```

Deleting a SLAM Book should also have an explicitly defined policy for
its friends. Prefer a transactional/cascade strategy only after
confirming the desired behavior with the Team Lead.

## 8. DTO Strategy

Do not expose JPA entities directly from controllers.

Use DTOs.

### CreateSlamBookRequest

Contains fields needed to create a SLAM Book.

### UpdateSlamBookRequest

Contains fields that may be modified.

### SlamBookResponse

Contains:

-   id
-   personal details
-   preferences
-   friendship details
-   song dedication
-   memory
-   timestamps as appropriate

### CreateFriendRequest

Contains friend contribution fields.

### UpdateFriendRequest

Contains editable friend fields.

### FriendResponse

Contains persisted friend information.

## 9. Create API

Endpoint:

``` http
POST /api/slam
```

Flow:

``` text
Request
   ↓
Controller
   ↓
DTO validation
   ↓
Service
   ↓
Business validation
   ↓
Image handling if required
   ↓
Repository
   ↓
PostgreSQL
   ↓
Response DTO
```

Return the generated SLAM Book ID so the frontend can use:

``` text
/slam/{id}
```

## 10. Get API

Endpoint:

``` http
GET /api/slam/{id}
```

Purpose:

Retrieve a saved SLAM Book.

This endpoint is critical for refresh persistence.

Flow:

``` text
/slam/101
   ↓
GET /api/slam/101
   ↓
Repository.findById(101)
   ↓
Return response
```

If the ID does not exist, return the documented not-found error.

## 11. Update API

Endpoint:

``` http
PUT /api/slam/{id}
```

Flow:

``` text
Request
   ↓
Validate
   ↓
Find existing SLAM Book
   ↓
Update allowed fields
   ↓
Save
   ↓
Return updated response
```

If the SLAM Book doesn't exist, return a not-found response.

## 12. Delete API

Endpoint:

``` http
DELETE /api/slam/{id}
```

Flow:

``` text
Request
   ↓
Find SLAM Book
   ↓
Delete according to defined relationship/storage policy
   ↓
Return success
```

The frontend must ask for confirmation before making this request.

## 13. Friend APIs

### Add Friend

``` http
POST /api/slam/{slamId}/friends
```

The friend must be associated with the specified SLAM Book.

### Get Friends

``` http
GET /api/slam/{slamId}/friends
```

Return all friend contributions for that SLAM Book.

### Update Friend

``` http
PUT /api/friends/{friendId}
```

### Delete Friend

``` http
DELETE /api/friends/{friendId}
```

These endpoints are required by the FRD.

## 14. Validation

Backend validation is mandatory.

### Full Name

Required.

### Friendship Rating

Allowed:

``` text
1–10
```

### About Me

Recommended maximum:

``` text
500 characters
```

### Memory

Recommended maximum:

``` text
500 characters
```

### Dates

Must be valid dates.

### Song URL

Must be valid when supplied.

### Images

Only supported image formats should be accepted.

Apply a reasonable image-size limit.

Invalid data must not be persisted.

## 15. Validation Example

Use Jakarta Bean Validation where appropriate.

Example:

``` java
@NotBlank
private String fullName;

@Min(1)
@Max(10)
private Integer friendshipRating;

@Size(max = 500)
private String aboutMe;

@Size(max = 500)
private String memoryText;
```

Do not use inappropriate validation annotations for incompatible Java
types.

## 16. Error Handling

Create a global exception handler.

Required user-facing error concepts:

``` text
Invalid data:
Please check the information entered.

SLAM Book not found:
The requested SLAM Book could not be found.

Save failure:
Unable to save your SLAM Book. Please try again.

Image upload failure:
Unable to upload the image. Please try again.

Delete success:
SLAM Book deleted successfully.
```

The API should return consistent HTTP status codes and a consistent JSON
error structure.

Suggested error structure:

``` json
{
  "success": false,
  "message": "The requested SLAM Book could not be found.",
  "timestamp": "2026-08-17T12:00:00"
}
```

## 17. Suggested Success Response Structure

Use a consistent response format.

Example:

``` json
{
  "success": true,
  "message": "SLAM Book retrieved successfully.",
  "data": {
    "id": 101,
    "fullName": "Example User"
  }
}
```

Keep the exact response wrapper consistent across endpoints.

## 18. Image Storage Architecture

Do not store profile/memory image binaries inside the main SLAM Book
PostgreSQL record.

Preferred flow:

``` text
Frontend
   ↓
Backend
   ↓
Supabase Storage
   ↓
Image URL
   ↓
PostgreSQL
   ↓
Frontend
```

Database stores:

``` text
profile_photo_url
memory_photo_url
```

The actual image lives in Supabase Storage.

## 19. Supabase Configuration

Use environment variables.

Required Render variables from the FRD include:

``` env
DB_URL=
DB_USERNAME=
DB_PASSWORD=
SUPABASE_URL=
SUPABASE_SERVICE_KEY=
CORS_ALLOWED_ORIGINS=
```

Never commit:

-   Database passwords
-   Service keys
-   Private credentials
-   Secrets

to GitHub.

## 20. PostgreSQL Configuration

Use environment-based configuration.

Conceptually:

``` properties
spring.datasource.url=${DB_URL}
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
```

Configure JPA/Hibernate according to the selected Spring Boot version
and PostgreSQL setup.

## 21. CORS

The frontend is deployed on Vercel and the backend on Render.

The backend must allow requests from the deployed frontend origin.

Development origins may also be allowed during local development.

Use:

``` text
CORS_ALLOWED_ORIGINS
```

rather than hard-coding production origins into application logic where
practical.

## 22. Production Communication

Development may use:

``` text
http://localhost:...
```

Production must use the deployed Render backend URL.

The frontend must receive the backend URL through:

``` env
VITE_API_BASE_URL
```

The production frontend must never depend on localhost.

## 23. API Contract Summary

``` text
POST   /api/slam
GET    /api/slam/{id}
PUT    /api/slam/{id}
DELETE /api/slam/{id}

POST   /api/slam/{slamId}/friends
GET    /api/slam/{slamId}/friends
PUT    /api/friends/{friendId}
DELETE /api/friends/{friendId}
```

## 24. Recommended HTTP Status Codes

Use standard REST semantics:

``` text
POST create       → 201 Created
GET success       → 200 OK
PUT success       → 200 OK
DELETE success    → 200 OK or 204 No Content
Validation error  → 400 Bad Request
Not found         → 404 Not Found
Unexpected error  → 500 Internal Server Error
```

## 25. Transaction Boundaries

Use transactions around operations that modify multiple related database
records.

Especially consider transaction boundaries for:

-   Creating a SLAM Book with related data
-   Updating a SLAM Book
-   Deleting a SLAM Book and its friend records

Do not automatically delete remote Supabase files unless the desired
lifecycle policy has been confirmed.

## 26. Testing

Test all APIs using Postman.

Minimum test coverage:

### SLAM Book

-   Create valid SLAM Book
-   Create invalid SLAM Book
-   Get existing SLAM Book
-   Get non-existing SLAM Book
-   Update existing SLAM Book
-   Update non-existing SLAM Book
-   Delete existing SLAM Book
-   Delete non-existing SLAM Book

### Friend

-   Add friend
-   Get friends
-   Update friend
-   Delete friend
-   Invalid friend data
-   Invalid SLAM Book ID

### Images

-   Supported image upload
-   Unsupported image format
-   Oversized image
-   Image URL persistence
-   Image retrieval

## 27. Deployment

Backend:

``` text
Java Spring Boot
       ↓
Render
```

Database:

``` text
PostgreSQL
       ↓
Supabase
```

Storage:

``` text
Images
       ↓
Supabase Storage
```

Frontend:

``` text
React
       ↓
Vercel
```

Production architecture:

``` text
User
  ↓
Vercel React Frontend
  ↓ HTTPS REST
Render Spring Boot Backend
  ├──→ Supabase PostgreSQL
  └──→ Supabase Storage
```

## 28. Features Explicitly Outside Initial Version

Do not implement unless separately requested:

-   User login
-   User registration
-   OTP authentication
-   Social authentication
-   Advanced security/privacy controls
-   AI-generated friendship analysis
-   Video messages
-   Voice messages
-   QR-code generation
-   PDF export
-   Advanced music-service integration
-   Advanced analytics/reporting
-   Complex administration

## 29. Seven-Day Backend-Oriented Plan

### Day 1

-   Spring Boot project setup
-   PostgreSQL/Supabase connection
-   Base package structure
-   Initial entity design
-   CORS configuration

### Day 2

-   SlamBook entity
-   Repository
-   DTOs
-   Service
-   Controller
-   POST API
-   Validation

### Day 3

-   GET API
-   ID handling
-   Response mapping
-   Refresh persistence integration

### Day 4

-   PUT API
-   DELETE API
-   Exception handling
-   Validation/error responses

### Day 5

-   Image handling
-   Supabase Storage integration
-   Profile image
-   Memory image
-   Song dedication support

### Day 6

-   Friend entity
-   Friend relationship
-   Friend CRUD
-   Friendship Wall API integration

### Day 7

-   End-to-end API testing
-   PostgreSQL verification
-   Image testing
-   CORS testing
-   Render deployment
-   Environment variables
-   Production bug fixing

## 30. Backend Acceptance Checklist

-   [ ] Spring Boot application starts successfully
-   [ ] PostgreSQL/Supabase connection works
-   [ ] SlamBook entity exists
-   [ ] Create API works
-   [ ] Get API works
-   [ ] Update API works
-   [ ] Delete API works
-   [ ] Friend create API works
-   [ ] Friend get API works
-   [ ] Friend update API works
-   [ ] Friend delete API works
-   [ ] Backend validation works
-   [ ] Invalid records are not persisted
-   [ ] Not-found errors are handled
-   [ ] Image URLs can be persisted
-   [ ] Supabase Storage integration works
-   [ ] CORS works with Vercel
-   [ ] Environment variables are used
-   [ ] Secrets are not committed
-   [ ] APIs work over HTTPS in production
-   [ ] Refresh retrieves saved data
-   [ ] Backend is deployed on Render

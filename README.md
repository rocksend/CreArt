# creart

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Firebase Authentication

1. In Firebase Console, enable **Authentication → Sign-in method → Email/Password**.
2. Register users from the app. Their profile is stored in `users/{uid}` and
   their username-to-email lookup is stored in `usernames/{username-lowercase}`.
3. To grant admin access, use the UID of an account created in the app and set
   `users/{uid}.role` to `admin` in Firestore. New registrations always receive
   the `user` role.
4. Configure Firestore Security Rules before release. Allow users to read their
   own profile, prevent clients from changing `role`, and allow username
   document lookups by ID without allowing clients to list the collection.
   Merge these permissions with the existing rules for artwork data; do not
   replace those rules blindly.
   The username lookup stores an email address, so allowing direct lookups can
   reveal the email for a known username. For production privacy, move username
   resolution to a trusted backend (for example, a callable Cloud Function).

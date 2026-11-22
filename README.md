# SUtory

A community-driven mobile app for Sabancı University students, built around topic-based boards where students can ask questions, share news, trade items, and find lost belongings.

> 🚧 **Status: Under development.** SUtory is being built as part of a course project. Features, screens, and structure will change as the project progresses.

## Why SUtory?

Sabancı University students currently have no single, dedicated place to connect with each other. Course questions, dorm issues, event announcements, second-hand sales, and lost-and-found requests end up scattered across group chats and social media, where they are easy to miss and hard to search.

SUtory aims to fill this gap with a simple, campus-only space where:

- Access is limited to students with a `@sabanciuniv.edu` email address
- Posts are organized into topic communities instead of getting lost in chat history
- The community itself surfaces the most useful content through voting

## Planned Features

- **Authentication:** sign up and log in with a university email
- **Home feed:** posts from all communities, sortable by newest or vote count
- **Communities:** browse topic boards (e.g. `su/Courses`, `su/Dorms`, `su/Events`, `su/Lost & Found`, `su/Marketplace`) and join them
- **Posts:** create, edit, and delete your own posts, with optional images
- **Comments and replies:** threaded discussions with upvote/downvote
- **Search:** find posts and communities, with filtering
- **Profile:** your posts, comments, and karma
- **Moderation:** report posts for spam, harassment, or inappropriate content

## Project Progress

| Step | Description | Status |
|------|-------------|--------|
| 2.1 | Wireframes and navigation flow | ✅ Done |
| 2.x | UI implementation | 🚧 In progress |
| 3 | Authentication and backend integration | ⏳ Planned |

The wireframes are available in this repository as `SUtory_Wireframes_Koyu_v2.pdf`.

## Flutter version

Flutter 3.50.0 (stable), Dart 3.14.0

## How to run

```bash
git clone https://github.com/SezginPark/SUtory-CS310.git
cd SUtory-CS310
flutter pub get
flutter run
```

Start an Android emulator first. Login and sign-up are UI only in this step: enter any email ending in `@sabanciuniv.edu` and any password.

## Team

**Group 43**, CS310 Mobile Application Development

- Fatih Onur Geçkil
- Melih Durhasan
- Sezgin Park

# Studyspace: live app

The app and Supabase backend are connected.

- **Open Studyspace:** https://knight-ux47.github.io/studyspace-app/
- **Public source repository:** https://github.com/Knight-ux47/studyspace-app
- **Supabase project:** `studyspace-app` in the `Studyspace` organization (Mumbai region)

## Using groups

1. Open the app and create an account or sign in.
2. Create a private group and share its invite code with friends.
3. Chat and compare weekly study time with group members. Enable **Share my timer with my selected group** before starting a timer to share live status.

Group data is protected by Supabase row-level security. Members can see their own data and the groups they join. The public GitHub repository contains the static app files and a Supabase **publishable** browser key; it does not contain a service-role key.

## What stays free

GitHub Pages can host this public repository on GitHub Free. Supabase Free is not a timed trial and does not automatically charge for over-limit usage; sustained overuse can restrict the service, and a quiet free project may pause after about a week. You can resume a paused project from the dashboard. Paid AI replies are not connected. The notes helper only searches files you choose inside your browser.

Each account chooses its own grade and exams after signing in; those choices live in that person’s private Supabase account metadata and follow their login. Notes, exam dates, checklist, study history, timetable, and selected note files are kept on the device in that account’s own local space. They are not uploaded to a group, and local notes/timetables do not sync between the website and APK. Group accounts, private chat, shared timers, and shared group sessions use Supabase.

## Android app

The Android project is in the `android` folder. A public GitHub Actions workflow builds an installable debug APK and saves it as a downloadable workflow artifact. The APK bundles the app screens on the phone. Supabase features still need internet; the local notes, exam tracker, checklist, timetable, and study timer stay on the device. Each person’s grade and selected exams personalize their own tabs and home summary. Friends do not need GitHub or Supabase dashboard accounts: they create a Studyspace account in the app, set up their own profile, and join with your group invite code.

The same APK cannot run on iPhone. An iOS app is a separate build that needs Xcode on a Mac and Apple’s signing process.

## Updating the app

The GitHub Pages site publishes from the repository's `main` branch at the repository root. To update it, replace the matching app files in the repository (`index.html`, `style.css`, `app.js`, `formula-data.js`, and `supabase-config.js`) and commit the changes. GitHub Pages will publish the new version. The Android workflow also runs when these app files or the Android project change.

The local tracker folder also includes `supabase-schema.sql`, the database setup used for this project. It has already been run; do not run it again because its policies are created once.

## Study-site blocking

A regular web page cannot block other browser tabs or websites. The app follows the timetable and runs the study timer; blocking websites requires a separate browser extension or site-blocking app.

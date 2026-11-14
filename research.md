# Study app research and feature plan

Reviewed 14 November 2026. This is a curated comparison of apps that match the requested combination of personal study tracking, planning, focus controls, and studying with friends. Prices and free limits may vary by country and app store; verify before subscribing.

## Apps worth studying

| App | Free / paid | Best ideas for Studyspace |
|---|---|---|
| [YPT — Yeolpumta](https://play.google.com/store/apps/details?id=com.pallo.passiontimerscoped) | Free with ads and in-app purchases | Subject timer, daily tasks, schedule, app blocking, private study groups, live status, rankings, and day/week/month summaries. Closest match to the request. |
| [Pogether](https://pogether.com/) | Free core features; optional upgrades | Camera-free private desks, shared Pomodoro, real-time presence, streaks, milestones, and group challenges. Closest reference for a lightweight friend group. |
| [StudyDuo](https://studyduo.app/study-together-app) | Free tier includes 1 hour/day of video rooms, tasks, chat, streaks and badges; 14-day Premium trial. Premium is listed at $4.99/month or $49.99/year in its [terms](https://studyduo.app/terms-of-service). | Friend invites, chat, tasks, achievements, synchronized study rooms, privacy controls, and cross-device accounts. More video/social than needed for a quiet study group. |
| [Focusmate](https://www.focusmate.com/features/) | 3 sessions/week free; Plus $8/month billed yearly or $12 monthly on its [pricing page](https://www.focusmate.com/pricing/) | Start/end check-ins, stated session goal, quiet mode, favorite partners, calendar booking, and accountability. Good structure for planned group sprints. |
| [Forest](https://www.forestapp.cc/) | Core timer, blockers, focus tracking, Plant Together, friends, and leaderboard are listed as free; Plus adds customization and expanded analytics. Store pricing varies. | Shared focus commitment, app/site blocking, ambient sound, analytics, group focus, and cooperative challenges. |
| [Flora](https://apps.apple.com/us/app/flora-green-focus/id1225155794) | Free with in-app purchases; pricing varies by store | To-do list, habits, distraction blocking, focus rooms with friends, and gentle rewards. Strong phone-first focus inspiration. |
| [Study Bunny](https://play.google.com/store/apps/details?id=com.superbyte.studybunny) | Free with ads and in-app purchases | Study timer, pause support, To-do list, flashcards, customizable tracker, and low-stakes rewards. Useful solo study ideas. |
| [MyStudyLife](https://mystudylife.com/faq/) | Core planner free; optional paid MSL+ varies by country | Classes, tasks, exams, extracurriculars, reminders, subtasks, and cross-device schedule sync. Best reference for student planning rather than social focus. |

## Recommended additions for this tracker

### Build first

1. **Private groups:** create a group, invite by short code or link, approve/remove members, and let the owner close or reset the group.
2. **Live member cards:** show studying, on break, or offline; current subject; elapsed study and break time; and today's total. Never count a paused or idle timer as study.
3. **Shared focus rooms:** camera-free by default, with a synchronized start, optional Pomodoro blocks, and a short goal/check-in at the start and end.
4. **Member chat:** group-only messages, mute controls, and the ability to remove/report members. Keep the room quiet during focus sessions; allow chat on breaks.
5. **Fair comparisons:** opt-in daily/weekly leaderboard based on completed study seconds, subject filters, and an option to hide totals. Exclude breaks and incomplete sessions.
6. **Study goals:** daily and weekly targets, progress toward the target, streak history, and completion summaries by subject.
7. **Checklist improvements:** due dates, subtasks, subject tags, and marking a task complete from the timer's finish flow.
8. **Privacy and account controls:** private-by-default profile, no public directory, no camera/location requirement, export/delete account, and clear controls for sharing subject and timer status.

### Keep optional

- Ambient sound, badges, milestones, and challenges can motivate without distracting from studying.
- Video, public rooms, global rankings, and social feeds should stay out of the first release. They add moderation, privacy, and maintenance work without being needed for a small friend group.

## Current feature boundaries

The public Studyspace site and Android APK use the connected Supabase project for login, private groups, chat, shared live timers, and group study sessions. Each friend creates a Studyspace account in the app; they do not need a GitHub or Supabase dashboard account. Subject notes, imported study files, exam dates, checklist items, and timetable stay on that user's device. Files selected for the local helper are not uploaded. OpenAI-generated answers are intentionally not included because the user wants to avoid usage charges. A webpage cannot block other tabs, and an Android APK does not install on iOS; iOS needs a separate Xcode build.

## Sources

- [YPT on Google Play](https://play.google.com/store/apps/details?id=com.pallo.passiontimerscoped)
- [Pogether](https://pogether.com/)
- [StudyDuo features and free plan](https://studyduo.app/study-together-app), [StudyDuo terms and pricing](https://studyduo.app/terms-of-service)
- [Focusmate features](https://www.focusmate.com/features/), [Focusmate pricing](https://www.focusmate.com/pricing/)
- [Forest features and plan comparison](https://www.forestapp.cc/)
- [Flora on the App Store](https://apps.apple.com/us/app/flora-green-focus/id1225155794)
- [Study Bunny on Google Play](https://play.google.com/store/apps/details?id=com.superbyte.studybunny)
- [MyStudyLife FAQ](https://mystudylife.com/faq/), [MyStudyLife features](https://mystudylife.com/tour/)
- [Brilliant FAQ](https://brilliant.org/faq/) and [interactive learning overview](https://brilliant.org/help/using-brilliant/who-is-brilliant-for/): supports the short active-recall question with immediate feedback pattern.

## Formula library and interface references

- [College Board’s Bluebook tools](https://bluebook.collegeboard.org/students/tools) confirms that Math tests include an in-test reference sheet. The app includes those core geometry formulas plus additional SAT Math study relations.
- [SAT Math reference sheet and test directions](https://satsuite.collegeboard.org/media/pdf/english-sat-test-directions-bb.pdf) is the primary source for the circle, triangle, special-triangle, solid-volume, angle, and radian relations.
- [NTA JEE Main 2027 syllabus](https://jeemain.nta.nic.in/document/syllabus-2027/) is the topic map for the JEE Math, Physics, and Chemistry references. NTA publishes a syllabus, not a single comprehensive master formula sheet, so the app labels its collection as a study reference.
- [Apple Human Interface Guidelines: Materials](https://developer.apple.com/design/human-interface-guidelines/materials) recommends using Liquid Glass for navigation and controls while keeping the main study content on clearer standard surfaces. Studyspace follows that distinction in its sidebar, top bar, and focus overlays.
- [Khan Academy’s Learner Home overview](https://support.khanacademy.org/hc/en-us/articles/360030629852-What-is-my-Learner-Home-page-and-what-can-I-do-there) describes a signed-in home organized around chosen classes and courses, with activity and progress visible together. [Its course personalization guide](https://support.khanacademy.org/hc/en-us/articles/115003342971-How-do-I-edit-the-My-Courses-section-on-my-Home-page) supports asking for grade/subjects during setup and letting each learner change them later. Studyspace uses the same useful pattern for a per-account exam setup and customized Home summary.
- [Quizlet’s study path guidance](https://help.quizlet.com/hc/en-us/articles/360048314692-Setting-up-a-study-path) describes goal selection and level-aware study choices, supporting a short personal setup before surfacing study content.

## Cost and local file handling

- [GitHub Pages limits](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits): public repositories can use Pages on GitHub Free.
- [Supabase billing](https://supabase.com/docs/guides/platform/billing-on-supabase) and [cost controls](https://supabase.com/docs/guides/platform/cost-control): the app is designed to remain on Free; exceeding quotas can restrict service rather than cause automatic free-plan overage charges.
- OpenAI API access and file search were intentionally left out after the user chose to avoid paid usage. The in-browser note helper reads user-selected text/Markdown/CSV/PDF files locally and searches matching passages; it does not generate AI answers or upload the files.

# ✦ Nawah (نواة) - Master Architecture & Audit Artifact ✦

هذه الوثيقة تمثل المراجعة المعمارية الشاملة (Audit) لواجهة المستخدم الخاصة بتطبيق "نواة"، بالإضافة إلى الخطة الرئيسية (Master Plan) لهندسة قواعد البيانات وربط الواجهة الخلفية (Backend) السحابية باستخدام Laravel.

---

## 📱 المرحلة الأولى: تدقيق شامل لواجهة المستخدم وتقسيم الشاشات (Frontend Audit)

تم فحص كل ملفات التطبيق وشاشاته بُناءً على بنية المشاريع الحديثة في Flutter، وفيما يلي التفصيل المعماري الدقيق لكل شاشة مع تأكيد التوافق التام مع نظام iOS.

### 1️⃣ التدقيق الشامل للشاشات (Screen-by-Screen Breakdown)

1. **شاشة البداية (Splash Screen - `splash_screen.dart`)**
   - **الهدف**: واجهة الترحيب عند فتح التطبيق وتمهيد تحميل البيانات.
   - **العناصر الأساسية**: شعار التطبيق (Animation متدرج)، اسم التطبيق "نواة"، مؤشر تحميل (CircularProgressIndicator)، وتسمية لنسخة التطبيق التجريبية (Beta Version).

2. **شاشة تسجيل الدخول (Login Screen - `login_screen.dart`)**
   - **الهدف**: مصادقة المستخدمين الحاليين.
   - **العناصر الأساسية**: شعار التطبيق، حقل إدخال البريد الإلكتروني (أو الاسم)، حقل إدخال كلمة المرور (مع ميزة الإخفاء/الإظهار)، زر تسجيل الدخول (Gradient Button)، ورابط للانتقال لشاشة إنشاء الحساب.

3. **شاشة إنشاء الحساب (SignUp Screen - `signup_screen.dart`)**
   - **الهدف**: تسجيل المستخدمين الجدد.
   - **العناصر الأساسية**: حقول إدخال (الاسم الكامل، البريد الإلكتروني، كلمة المرور، تأكيد كلمة المرور مع التحقق من التطابق)، زر الإرسال، ورابط للعودة لتسجيل الدخول.

4. **الشاشة الرئيسية (Home Screen - `home_screen.dart`)**
   - **الهدف**: لوحة التحكم الأساسية لعرض المشاريع، الإحصائيات، والأهداف اليومية.
   - **العناصر الأساسية**: 
     - ترحيب مخصص (مرحباً، راشد).
     - شريط التقدم للهدف اليومي (Daily Goal Progress).
     - تصنيفات المشاريع (الكل، روايات، أفكار، مخططات).
     - شبكة عرض المشاريع (GridView) مع زر "إضافة مشروع جديد".
     - قسم النشاط الأخير (Recent Activity).

5. **شاشة عرض كل المشاريع (View All Projects - `view_all_projects_screen.dart`)**
   - **الهدف**: استعراض المشاريع بكفاءة مع دعم التقسيم لصفحات (Pagination).
   - **العناصر الأساسية**: شبكة المشاريع، أزرار التنقل بين الصفحات (السابق، التالي، أرقام الصفحات).

6. **مُحرر النصوص الأساسي / الروايات (Editor Screen - `editor_screen.dart`)**
   - **الهدف**: بيئة كتابة هادئة خالية من التشتت (Distraction-free).
   - **العناصر الأساسية**: شريط أدوات التنسيق (Bold, Italic, Alignment)، حقل عنوان الفصل، مساحة الكتابة الرئيسية، وشريط سفلي يعرض (عدد الكلمات، الحالة: جاري الحفظ / تم الحفظ).

7. **مُحرر الأفكار (Idea Editor Screen - `idea_editor_screen.dart`)**
   - **الهدف**: تنظيم الأفكار على شكل بطاقات (Cards) ملونة مرنة.
   - **العناصر الأساسية**: قائمة بالبطاقات (شخصية، حبكة، مكان، إلهام)، زر إضافة بطاقة جديدة، إمكانية تعديل البطاقات.

8. **مُحرر المخططات (Outline Editor Screen - `outline_editor_screen.dart`)**
   - **الهدف**: بناء الخطوط الزمنية وتسلسل الأحداث.
   - **العناصر الأساسية**: مؤشر زمني رأسي (Timeline Indicator)، عقد (Nodes) قابلة لإعادة الترتيب (ReorderableListView)، كل عقدة تحتوي على عنوان، وصف، و(Tags).

9. **مُحرر النصوص المقيد للضيوف (Restricted Editor Screen - `editor_restricted_screen.dart`)**
   - **الهدف**: عرض الفصول للضيوف/المحررين مع منع التعديل المباشر، والسماح بتقديم "اقتراحات".
   - **العناصر الأساسية**: مساحة نصية للقراءة فقط (SelectableText)، قائمة منبثقة (Context Menu) مخصصة لاقتراح تعديل عند تظليل النص، وزر (FAB) لإضافة اقتراح عام.

10. **شاشة التحرير المُسند (Editing Screen - `editing_screen.dart`)**
    - **الهدف**: عرض المشاريع التي تم تكليف المستخدم بتعديلها كمُحرر من قبل كُتّاب آخرين.
    - **العناصر الأساسية**: بطاقة للكاتب، وقائمة مشاريع موضح عليها الحالة التنبيهية (مثال: "اقتراحات معلقة"، "يحتاج مراجعة").

11. **شاشة مراجعة التعديلات (Review Edits Screen - `review_edits_screen.dart`)**
    - **الهدف**: مراجعة الكاتب الأصلي للاقتراحات المقدمة من المحررين.
    - **العناصر الأساسية**: واجهة مقارنة (Diff View) توضح النص الأصلي والمقترح، أزرار (قبول / رفض)، ونافذة منبثقة لإدخال "سبب الرفض" (Rejection Reason).

12. **شاشة إدارة الصلاحيات (Access Control Screen - `access_control_screen.dart`)**
    - **الهدف**: تحكم الكاتب بالمحررين وصلاحياتهم.
    - **العناصر الأساسية**: قائمة بالمحررين، حالة الاتصال (Online/Offline)، إمكانية تغيير مستوى الصلاحية (Full, Read-Only, Suggest-Only)، إيقاف مؤقت لحساب المحرر (Pause).

13. **شاشة الإشعارات (Notifications Screen - `notifications_screen.dart`)**
    - **الهدف**: مركز التنبيهات.
    - **العناصر الأساسية**: فلترة الإشعارات (اليوم، أقدم)، أيقونات دلالية، تمييز الإشعارات غير المقروءة، وقدرة على عرض سبب الرفض للاقتراحات المرفوضة.

14. **شاشة الملف الشخصي (Profile Screen - `profile_screen.dart`)**
    - **الهدف**: عرض إحصائيات وإعدادات المستخدم.
    - **العناصر الأساسية**: الصورة الشخصية، الإحصائيات (أيام الكتابة، التفاعلات، المشاريع)، إعدادات الثيم (Light/Dark)، الأمان، وتسجيل الخروج.

---

### 2️⃣ التوافق الصارم مع أنظمة iOS (100% Strict iOS Optimization)

تم فحص التطبيق من منظور هندسة iOS، والتطبيق مُهيأ بشكل ممتاز ليتوافق مع أحدث أجهزة Apple (مثل iPhone 15/16 Pro):
- **Dynamic Island & Safe Area**: يُستخدم الودجت `SafeArea` في كافة الشاشات بشكل صحيح لمنع تداخل المحتوى مع الـ Dynamic Island والـ (Home Indicator) في الأسفل. في بعض الشاشات تم تخصيص `bottom: false` للسماح بالقوائم بالانزلاق بحرية تحت الـ Home Indicator لمعمارية (Edge-to-Edge) جذابة.
- **Cupertino Transitions**: تم ضبط خوارزمية التنقل في `app_theme.dart` على `CupertinoPageTransitionsBuilder`، مما يُعطي تأثير السحب الجانبي (Swipe back) المألوف بشكل أصلي في iOS.
- **Bouncing Scroll Physics**: تم تخصيص سلوك التمرير الدائم `NawahScrollBehavior` ليتوافق مع الانعكاس المرن (Bouncing) المميز لنظام iOS، وتجاوز تأثير التوهج (Overscroll Glow) الخاص بـ Android بالكامل.
- **خلو تام من أكواد Android المزعجة**: لا توجد تأثيرات Material Ripple قوية، والتصاميم تعتمد على الألوان الهادئة، والزوايا الدائرية الناعمة (BorderRadius.circular)، والظلال الخفيفة التي تحاكي لغة تصميم Apple الحديثة.

💡 **نصيحة تحسينية**: التطبيق حالياً رائع، ولكن يُنصح لاحقاً بإضافة `flutter_vibrate` لتقديم رجفان خفيف (Haptic Feedback) عند ضغط الأزرار المهمة (مثل قبول/رفض التعديل)، مما يعزز الإحساس الفاخر في الآيفون (Taptic Engine).

---

## ⚙️ المرحلة الثانية: هندسة Backend (Laravel) وخطة الربط الذكية

من أجل تحويل هذا التطبيق غير المتصل حالياً إلى نظام سحابي تفاعلي وقوي، سيتم بناء Backend باستخدام Laravel.

### 1️⃣ هيكلة قواعد البيانات (Database Schema Design)

بناءً على الشاشات، صممت قاعدة بيانات علائقية (Relational MySQL/PostgreSQL) مُحسنة للأداء:

*   **جدول `users`**:
    *   `id` (PK)
    *   `name`, `email`, `password`
    *   `role` (writer / editor)
    *   `settings_json` (theme info, daily goal, etc.)

*   **جدول `projects`**:
    *   `id` (PK)
    *   `owner_id` (FK -> users)
    *   `title`, `type` (novel, idea, outline)
    *   `word_count`
    *   `last_edited_at`

*   **جدول `project_categories` (للتصنيفات / Tags)**:
    *   `project_id` (FK), `category_name`

*   **جدول `chapters` (للروايات)**:
    *   `id` (PK), `project_id` (FK), `title`, `content` (LONGTEXT)
    *   `order_index` (للترتيب)

*   **جدول `idea_cards` (لشاشة الأفكار)**:
    *   `id` (PK), `project_id` (FK), `category` (شخصية، مكان، إلخ), `content`

*   **جدول `outline_nodes` (لشاشة المخططات)**:
    *   `id` (PK), `project_id` (FK), `title`, `description`
    *   `order_index`, `is_expanded`

*   **جدول `permissions` (للصلاحيات - Access Control)**:
    *   `id` (PK), `project_id` (FK), `editor_id` (FK -> users)
    *   `access_level` (full, suggest-only, read-only)
    *   `is_paused` (boolean)

*   **جدول `suggestions` (للتعديلات المقترحة)**:
    *   `id` (PK), `chapter_id` أو `card_id`
    *   `editor_id` (FK -> users)
    *   `original_text`, `suggested_text`
    *   `status` (pending, accepted, rejected)
    *   `rejection_reason` (TEXT - NULLABLE)

*   **جدول `notifications`**:
    *   `id` (PK), `user_id` (FK), `type`, `title`, `body`
    *   `is_read` (boolean), `reference_id` (رقم الاقتراح أو المشروع)

---

### 2️⃣ جسر الربط وبروتوكولات الـ API (Integration Bridge)

سيتم استخدام **RESTful JSON APIs** محمية بنظام **Laravel Sanctum** لإصدار توكنات (API Tokens).

- **Authentication**:
  - `POST /api/auth/login` و `POST /api/auth/register` (إرجاع Bearer Token).
- **Projects & Content**:
  - `GET /api/projects` (مع دعم Pagination كالذي في الشاشة).
  - `POST /api/projects/{id}/chapters` (للحفظ).
- **Collaboration & Roles**:
  - `GET /api/projects/{id}/editors` (استدعاء قائمة المحررين وصلاحياتهم).
  - `POST /api/suggestions/accept` و `POST /api/suggestions/reject` (مع تمرير `reason`).

---

### 3️⃣ إدارة الحالة والتزامن السحابي (State & Sync Logic)

لتقديم تجربة كتابة سلسة دون انقطاع وخسارة البيانات:

1. **تقنية الحفظ التلقائي الذكي (Debounced Auto-save)**
   - **المشكلة**: حفظ النص عند كل حرف يضغط على السيرفر ويبطئ التطبيق.
   - **الحل**: تنفيذ قاعدة (Debounce) بمدة `1500ms` إلى `2000ms`. سيرسل التطبيق طلب `PUT /api/chapters/{id}/sync` فقط عندما يتوقف المستخدم عن الكتابة لمدة ثانيتين.
   - **واجهة المستخدم**: سيقوم Flutter بمراقبة `State` (يتم الرفع -> "جاري الحفظ..." -> النجاح -> "تم الحفظ").
   - **Local Caching (First-Offline)**: نقترح إضافة `Isar Database` محلياً لتخزين الفصول تزامناً مع السيرفر، ليعمل التطبيق في عدم وجود تغطية خلوية، وتتم المزامنة (Sync) فور عودة الإنترنت.

2. **المشاركة اللحظية وهويات التحرير (Real-time ID Sharing & WebSockets)**
   - **المشكلة**: نحتاج لأن يرى الكاتب اقتراحات المحرر فورياً، وأن يعرف إذا كان المحرر (Online).
   - **الحل السحابي (Laravel Reverb / Pusher)**: 
     - تفعيل WebSockets. 
     - القناة الأولى: `Presence Channel` لغرفة المشروع تتيح إظهار أيقونة (يكتب الآن... / متصل).
     - القناة الثانية: لبث (Broadcast) صانع "الاقتراح الجديد" عبر مقبس (Socket Event) يقرأه Flutter ويعرض (Top Notification) للكاتب.

---
**تمت المراجعة والتخطيط بواسطة: AI Lead Architect**
*جاهزون للانتقال لمرحلة التنفيذ (EXECUTION) عند موافقتك.*

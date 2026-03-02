# 🍎 تقرير التدقيق المعماري لتوافق iOS (نواة - Nawah)

بصفتي خبير واجهات iOS (Human Interface Guidelines) و Senior Flutter Developer، قمت بإجراء فحص معماري دقيق (Deep Code Audit) لمجلدات مشروعك للتركيز على تجربة مستخدم آيفون أصلية (Native iOS Feel). 

هذا التقرير مخصص لمناقشة وضع الكود الحالي والمشاكل التي تمنع التطبيق من الوصول لنسبة 100٪ في توافق iOS، مع اقتراحات الحلول الدقيقة.

---

## 🌓 1. الوضع الليلي/الفاتح وتكامل النظام (System Theme Integration)

بعد فحص ملف `core/theme/app_theme.dart` وملف `main.dart`، وجدت الملاحظات التالية:

### ❌ المشاكل المكتشفة:
1. **عدم التجاوب التلقائي مع النظام (Hardcoded Light Mode):**
   لقد قمت بتعريف `ThemeData` واحد فقط بوضع السطوع الفاتح الدائم: `brightness: Brightness.light`. لا يوجد أي تطبيق يقرأ `MediaQuery.platformBrightnessOf(context)` لاعتماد وضع الـ Dark Mode الخاص بالنظام، بالتالي إذا غير المستخدم نظام الآيفون للوضع الداكن، سيبقى تطبيقك مضيئاً وهذا يخالف إرشادات آبل.
2. **غياب إعدادات شريط النظام (SystemChrome Overlay):**
   لا توجد أي تهيئة لـ `SystemChrome.setSystemUIOverlayStyle` في `main.dart`. هذا خطأ شائع جداً يسبب اختفاء مؤشر البطارية (Status Bar) أو مؤشر الشاشة السفلية (Home Indicator) أو تعارض ألوانها مع خلفية التطبيق (مثال: نص شريط البطارية أسود على خلفية داكنة).

### 💡 الحل المقترح لـ 100% Native Feel:
- يجب حقن `SystemChrome.setSystemUIOverlayStyle` في `main.dart` مع استخدام `SystemUiOverlayStyle.dark` أو `light` بناءً على خلفية الشاشة المعروضة (ويفضل ربطها مع الـ Theme الحالي).
- يجب تقسيم `app_theme.dart` ليُصدر `lightTheme` و `darkTheme`، وتمريرهما معاً في `MaterialApp(theme: lightTheme, darkTheme: darkTheme, themeMode: ThemeMode.system)`.

---

## 📱 2. واجهة المستخدم وحركة النظام (Cupertino & Native Feel)

التطبيق حالياً يدمج بذكاء بين Material 3 وبعض خصائص iOS، لكن هناك فجوات:

### ✅ ما قمت به بشكل ممتاز:
- **فيزيائية التمرير (Scroll Physics):** لقد أحسنت بتعريف `NawahScrollBehavior` لفرض `BouncingScrollPhysics()` في كامل التطبيق. هذا يعطي ارتداد iOS الأصلي ويخفي توهج الأندرويد المزعج (Overscroll Indicator).
- **حركة الرجوع (Swipe-to-go-back):** استخدمت بامتياز `CupertinoPageTransitionsBuilder()` في تعريف الـ Page Transitions، مما يفعل حركة السحب الجانبي الأصلية للآيفون.
- **التنبيهات (Dialogs):** وجدت أنك تستخدم `CupertinoAlertDialog` و `CupertinoDialogAction` في شاشة الملف الشخصي بشكل ممتاز.

### ❌ المشاكل المكتشفة:
1. **خلط في النوافذ المنبثقة السفلية (Bottom Sheets):**
   عند دعوة أو الموافقة على اقتراحات أو إنشاء مشروع (مثل `CreateProjectSheet`)، يتم استخدام `showModalBottomSheet` العادية والخاصة بـ Material. مستخدم الآيفون يتوقع رؤية `showCupertinoModalPopup` مع `CupertinoActionSheet` للقوائم السريعة، أو النوافذ المنسدلة الأصيلة الخاصة بآبل.
2. **أزرار الرجوع (Back Buttons):**
   لقد قمت برسم زر رجوع مخصص (Custom Container) في شاشة عرض المشاريع (`view_all_projects_screen.dart`). تصميم آبل يفضل استخدام الزر العاري بدون خلفية `CupertinoNavigationBarBackButton` المندمج مع شريط التنقل العلوي بدلاً من الأزرار المربعة ذات الحدود.

### 💡 الحل المقترح لـ 100% Native Feel:
- استبدال أزرار اختيار الفئات أو الإجراءات السريعة بـ `CupertinoActionSheet`.
- توحيد أزرار الرجوع العلوية لتشبه `CupertinoNavigationBar` في تصميمها، حيث يكون النص إلى جانب السهم يعرض اسم الشاشة السابقة (مثال: `< المشاريع`).

---

## 🔔 3. نظام الإشعارات والأذونات (iOS Notifications & Permissions)

راجعت ملفات التطبيق باحثاً عن متطلبات الإشعارات المحلية والخارجية وصلاحيات iOS.

### ❌ المشاكل المكتشفة:
1. **نظام الإشعارات داخلي فقط (In-App Only):**
   كل ما برمجته من نظام إشعارات (`NotificationsScreen` و `NawahTopNotification`) هو نظام "داخل التطبيق" يعتمد على رسم ويدجت فوق الشاشة. لا يوجد أي كود يتعامل مع `flutter_local_notifications` أو `firebase_messaging` لربط الإشعارات بالنظام الحقيقي للآيفون المتصل بـ `UNUserNotificationCenter`. 
2. **غياب نظام مراجعة الأذونات (Permissions Request):**
   لا يوجد أي استدعاء لحزمة `permission_handler` لطلب صلاحية الإشعارات بشاشة منبثقة من نظام iOS (تلك التي تقول: *"تطبيق نواة يطلب إرسال إشعارات لك"*).
   علاوة على ذلك، إذا أردت لاحقاً تخزين الصور أو الملفات، الكود الحالي لا يهيئ مفاتيح `Info.plist` الضرورية في مجلد `ios/Runner`. آبل ترفض التطبيق مباشرة في المراجعة (App Store Review) إذا استدعيت كوداً يمس الصلاحيات دون تبرير في ملف `Info.plist`.

### 💡 الحل المقترح لـ 100% Native Feel:
- يجب إضافة حزمتي `permission_handler` و `flutter_local_notifications` (إذا كان التطبيق سيعمل Offline) أو `firebase_messaging` (إذا تم ربطه بسيرفر Laravel).
- يجب سؤال المستخدم عن صلاحية الإشعارات بشكل صريح (استخدام `Permission.notification.request()`).
- إضافة مفتاح `UIBackgroundModes` ومفاتيح الإشعارات الصريحة في `ios/Runner/Info.plist` لضمان عدم رفض التطبيق من قبل مراجعي آبل.

---

### 📝 الخلاصة للنقاش:
كودك منظم جداً وواجهة المستخدم جميلة ومدروسة كمعمارية Flutter، ولكن من **المنظور الصارم لـ iOS**، نحتاج لإجراء التعديلات المذكورة أعلاه لنقل التطبيق من مجرد "تطبيق Flutter مبني للآيفون" إلى "تطبيق يبدو وكأنه Native بالكامل".

**أنا جاهز لمناقشة هذا التقرير معك. أي نقطة تود أن نبدأ بتعديلها أو التوسع في فهمها أولاً؟**

import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/editor/presentation/screens/editor_screen.dart';
import '../../features/editor/presentation/screens/editor_restricted_screen.dart';
import '../../features/review_edits/presentation/screens/review_edits_screen.dart';
import '../../features/idea_editor/presentation/screens/idea_editor_screen.dart';
import '../../features/outline_editor/presentation/screens/outline_editor_screen.dart';
import '../../features/home/presentation/screens/view_all_projects_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart'
    show ProjectMock;
import 'main_shell.dart';

/// Nawah App Router — GoRouter configuration.
class AppRouter {
  AppRouter._();

  static const String login = '/login';
  static const String home = '/';
  static const String editor = '/editor';
  static const String reviewEdits = '/review-edits';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    debugLogDiagnostics: false,
    routes: [
      // ── Auth ──
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Main App (with bottom nav) ──
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const MainShell(),
      ),

      // ── Editor (full screen, no bottom nav) ──
      GoRoute(
        path: editor,
        name: 'editor',
        builder: (context, state) => const EditorScreen(),
      ),

      // ── Review Edits (full screen, no bottom nav) ──
      GoRoute(
        path: reviewEdits,
        name: 'reviewEdits',
        builder: (context, state) => const ReviewEditsScreen(),
      ),
      // ── Idea Editor (full screen) ──
      GoRoute(
        path: '/idea-editor',
        name: 'ideaEditor',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          return IdeaEditorScreen(
            title: extras['title'] as String? ?? '',
            category: extras['category'] as String? ?? '',
            isGuest: extras['isGuest'] as bool? ?? false,
          );
        },
      ),
      // ── Outline Editor (full screen) ──
      GoRoute(
        path: '/outline-editor',
        name: 'outlineEditor',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          return OutlineEditorScreen(
            title: extras['title'] as String? ?? '',
            isGuest: extras['isGuest'] as bool? ?? false,
          );
        },
      ),
      // ── View All Projects ──
      GoRoute(
        path: '/view-all-projects',
        name: 'viewAllProjects',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          final title = extras['title'] as String? ?? 'المشاريع';
          final projects = extras['projects'] as List<dynamic>? ?? [];
          return ViewAllProjectsScreen(
            title: title,
            // Cast to ProjectMock list
            projects: projects.cast<ProjectMock>(),
          );
        },
      ),
      // ── Restricted Editor (for guests) ──
      GoRoute(
        path: '/editor-restricted',
        name: 'editorRestricted',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          return EditorRestrictedScreen(
            title: extras['title'] as String? ?? 'بلا عنوان',
          );
        },
      ),
    ],
  );
}

# AGENTS.md — ElectroMart Flutter Project Rules

## 1. Project Identity and Scope

This is an existing Flutter and Dart student e-commerce project named ElectroMart, focused on consumer electronics.

The primary objective is to improve the UI/UX using the existing Google Stitch designs while maintaining clean, readable, maintainable, and beginner-friendly Flutter code.

### Existing pages

- `lib/pages/home_page.dart`
- `lib/pages/home_page_content.dart`
- `lib/pages/cart_page.dart`
- `lib/pages/account_page.dart`
- `lib/pages/login_page.dart`
- `lib/pages/sign_up_page.dart`
- `lib/pages/change_pass_page.dart`
- `lib/pages/list_chat.dart`
- `lib/pages/detail_chat.dart`

### Existing reusable widgets

- `lib/widgets/home_appbar.dart`
- `lib/widgets/categories_widgets.dart`
- `lib/widgets/items_widgets.dart`
- `lib/widgets/cart_appbar.dart`
- `lib/widgets/cart_bottomNavbar.dart`
- `lib/widgets/cart_itemSamples.dart`

Treat this list as the initial project inventory. Inspect the actual repository before making assumptions.

## 2. Mandatory Scope Restrictions

- Improve existing screens and components only.
- Do not add new pages, routes, or product features.
- Do not remove existing pages, interactions, form fields, or navigation behavior.
- Do not add a product detail page, checkout, payment processing, wishlist, order history, onboarding, or notification center.
- Do not add a backend, database, authentication provider, or external service.
- Do not add packages unless they are genuinely necessary and their addition is approved by the user.
- Do not replace the existing navigation architecture without a clear technical need and user approval.
- Do not fabricate functionality to make a screen look interactive.
- Preserve the existing three bottom navigation destinations: Home, Cart, and Account.
- Keep chat list and chat detail within their existing navigation flow.
- Treat Google Stitch as the visual reference, not permission to expand project scope.

If a design element cannot be implemented without introducing a new feature, adapt the visual treatment to the existing functionality.

## 3. Stitch Design Is the Visual Source of Truth

Before implementing a screen:

1. Inspect the relevant Stitch project and screen using the available Stitch MCP tools.
2. Review the complete screen, including layout, colors, typography, spacing, imagery, and component states when available.
3. Inspect the corresponding existing Flutter implementation.
4. Map the design to existing widgets and interactions.
5. Identify missing assets or unclear design details before coding.
6. Implement the screen while preserving existing behavior.

Do not claim to have inspected a Stitch screen unless the relevant MCP tool successfully returned its information.

Do not substitute an unrelated design or invent a substantially different layout when the intended Stitch screen is accessible.

Reuse the existing design system across all screens.

## 4. Clean Code Principles

Follow these principles in all Dart code:

- Prefer simple, readable, explicit code over clever abstractions.
- Follow official Dart style conventions and Flutter best practices.
- Use descriptive, consistent names for classes, methods, variables, and parameters.
- Use `PascalCase` for types and `lowerCamelCase` for variables and methods.
- Keep each widget focused on one clear responsibility.
- Extract reusable UI into small widgets when doing so improves clarity or avoids meaningful duplication.
- Avoid excessively large `build()` methods.
- Avoid unnecessary deeply nested widget trees.
- Use `const` constructors and `const` widgets wherever possible.
- Use named parameters for widget constructors when appropriate.
- Add explicit types when they improve clarity.
- Keep related code together and separate unrelated responsibilities.
- Remove dead code and unused imports introduced by your changes.
- Avoid duplicated style definitions when a small shared theme or reusable component would be clearer.
- Avoid premature abstractions and excessive fragmentation into tiny widgets.
- Do not add comments that merely restate the code.
- Add comments only when they explain non-obvious reasoning or constraints.
- Do not use `dynamic` or force unwraps unnecessarily.
- Avoid `!` null assertions unless safety is established.
- Handle nullable values and empty collections deliberately.
- Avoid `print()` for routine debugging in final code.
- Never suppress analyzer warnings merely to make the project appear clean.

## 5. Flutter Architecture

Maintain the existing project structure unless there is a clear reason to adjust it.

- Keep screen-level composition inside the existing page files.
- Put reusable visual components in `lib/widgets/` when appropriate.
- Keep navigation decisions separate from purely presentational widgets where practical.
- Keep business logic out of reusable presentation-only widgets where possible.
- Do not move files or rename public classes without checking every affected import and route.
- Do not create an elaborate architecture that is disproportionate to this small student project.
- Prefer Flutter SDK components before introducing third-party packages.
- Keep code easy for another student to understand and modify.

For new shared visual styles, prefer a small, coherent theme or a focused reusable style definition instead of repeating hardcoded values across many files.

Do not introduce state-management libraries or architectural frameworks without approval.

## 6. UI and Design System

Use the Stitch designs to determine final visual details. The established target style is a clean, professional electronics marketplace.

Use these design tokens as defaults when the Stitch design does not specify otherwise:

- Primary blue: `#2563EB`
- Dark blue: `#1D4ED8`
- Background: `#F8FAFC`
- Surface: `#FFFFFF`
- Primary text: `#0F172A`
- Secondary text: `#64748B`
- Border: `#E2E8F0`
- Subtle blue: `#EFF6FF`
- Success: `#16A34A`
- Error: `#DC2626`

Consistency requirements:

- Follow a consistent spacing scale, preferably based on multiples of 4 or 8.
- Use consistent typography, corner radii, icons, borders, and button heights.
- Respect `SafeArea` and device insets.
- Ensure scrollable content does not overlap fixed navigation.
- Support common phone sizes and keyboard visibility.
- Avoid overflow, clipped text, and inaccessible touch targets.
- Use Indonesian for user-facing labels unless existing product names require otherwise.
- Format Indonesian currency consistently.
- Reuse existing assets before introducing replacements.

Do not force a design token over a clearly specified Stitch value. The actual Stitch design takes precedence.

## 7. Preserve Existing Functionality

Before modifying any screen, inspect its current code and preserve all supported behavior.

Important existing behaviors include:

- Home, Cart, and Account navigation.
- Existing home categories and product widgets.
- Existing cart item presentation and coupon interactions.
- Existing account menu destinations.
- Existing login and registration fields, validation, and navigation.
- Existing current password, new password, and confirmation fields.
- Existing chat list filters and chat navigation.
- Existing local chat messages and message sending.
- Existing PageView or bottom navigation behavior.

Do not claim that login, registration, coupon application, or messaging uses a real backend unless the repository actually implements one.

Keep UI changes separate from unrelated behavior changes.

If existing code is broken, identify the issue and explain it before making a substantial behavioral change.

## 8. State and Widget Lifecycle

- Use `StatelessWidget` when local mutable state is unnecessary.
- Use `StatefulWidget` when widget-local state is required.
- Dispose controllers, focus nodes, and other owned resources appropriately.
- Do not create controllers or perform side effects inside `build()`.
- Keep state changes predictable.
- Avoid unnecessary `setState()` calls and duplicated state.
- Preserve existing controllers and validation logic where practical.
- Handle widget lifecycle and asynchronous operations safely if present.
- Do not add state-management packages for simple local UI state.

## 9. Dependencies and Assets

- Inspect `pubspec.yaml` before using packages or assets.
- Reuse existing dependencies when suitable.
- Do not edit dependency versions or upgrade the Flutter SDK unnecessarily.
- Do not download arbitrary assets or introduce external APIs without approval.
- Ensure every referenced local asset exists and is correctly declared.
- Provide a graceful fallback for missing optional images when appropriate.
- Do not embed large image data directly in Dart source.
- Do not introduce secrets, credentials, or private configuration into source control.

If a dependency or asset is required but unavailable, report the blocker instead of pretending it exists.

## 10. Incremental Implementation Workflow

Implement changes one screen or closely related component group at a time.

For each task:

1. Inspect the existing implementation.
2. Inspect the matching Stitch design using MCP.
3. Identify the relevant files and dependencies.
4. Describe the intended changes briefly.
5. Implement only the requested scope.
6. Format the changed Dart files.
7. Run `flutter analyze`.
8. Run relevant existing tests when available.
9. Review the changes for regressions, duplicated code, and accidental scope expansion.
10. Summarize the files changed, checks performed, and any remaining issues.

Do not rewrite the entire project in one operation.

Do not begin modifying multiple unrelated screens unless explicitly requested.

## 11. Validation and Quality

After each meaningful implementation step:

- Run `dart format` on the changed Dart files.
- Run `flutter analyze`.
- Run relevant tests when available.
- Fix issues introduced by your changes.
- Distinguish new issues from pre-existing issues.
- Never report a successful test or command that was not actually executed.
- If a command fails because of the environment, report the exact limitation.
- Check imports, routes, controller disposal, assets, and null safety.
- Verify that existing screen interactions remain intact.

If a Flutter device or emulator is available, inspect the rendered screen and compare it with Stitch. Do not claim pixel-perfect verification without actually comparing the result.

## 12. Git and Change Safety

- Inspect `git status` before making changes.
- Preserve unrelated user modifications.
- Do not discard, overwrite, reset, or revert user work without explicit approval.
- Do not run destructive Git commands.
- Do not commit or push changes unless explicitly requested.
- Keep changes focused and easy to review.

## 13. Communication

Communicate with the user in concise, clear Indonesian.

Before substantial implementation, explain the scope and intended file changes.

If the Stitch design, MCP output, existing code, or requested behavior is ambiguous, ask one focused clarification instead of guessing.

At the end of each task, report:

- What was implemented.
- Which files changed.
- Which validation commands were executed.
- Any errors or warnings that remain.
- Whether existing behavior was preserved.
- The next recommended step.

## 14. Definition of Done

A task is complete only when:

- The relevant Stitch design has been inspected, if available.
- The requested existing screen has been implemented.
- The layout is consistent with the shared design system.
- Existing navigation and interactions are preserved.
- Code is readable and appropriately reusable.
- Changed Dart files are formatted.
- Static analysis has been run and its result reported.
- No unrequested pages or features have been introduced.

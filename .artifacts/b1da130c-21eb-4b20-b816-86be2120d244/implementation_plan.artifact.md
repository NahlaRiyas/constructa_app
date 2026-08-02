# Responsive Refactor with MediaQuery

This plan outlines the steps to refactor hardcoded dimensions and font sizes to use `MediaQuery` based scaling using the global `w` and `height` variables.

## Proposed Changes

### [Component Name]

#### [MODIFY] [onboarding_screen.dart](file:///C:/Users/nahla/AndroidStudioProjects/constructa_app/lib/core/common/welcome_screens/onboarding_screen.dart)
- Convert all `Padding`, `SizedBox`, `Container` sizes, and `FontSize` to use `w` and `height`.

#### [MODIFY] [splash_screen.dart](file:///C:/Users/nahla/AndroidStudioProjects/constructa_app/lib/core/common/welcome_screens/splash_screen.dart)
- Convert all `Padding`, `SizedBox`, `Container` sizes, and `FontSize` to use `w` and `height`.

#### [MODIFY] [login_screen.dart](file:///C:/Users/nahla/AndroidStudioProjects/constructa_app/lib/core/common/authentication_screens/login_screen.dart)
- Convert all sizes to responsive variants.

#### [MODIFY] [signup_screen.dart](file:///C:/Users/nahla/AndroidStudioProjects/constructa_app/lib/core/common/authentication_screens/signup_screen.dart)
- Convert all sizes to responsive variants.

#### [MODIFY] [forgot_password.dart](file:///C:/Users/nahla/AndroidStudioProjects/constructa_app/lib/core/common/authentication_screens/forgot_password.dart)
- Convert all sizes to responsive variants.

#### [MODIFY] [home_screen.dart](file:///C:/Users/nahla/AndroidStudioProjects/constructa_app/lib/core/common/navigation_screens/home_screen.dart)
- Convert all sizes to responsive variants.

#### [MODIFY] [profile_screen.dart](file:///C:/Users/nahla/AndroidStudioProjects/constructa_app/lib/core/common/navigation_screens/profile_screen.dart)
- Convert all sizes to responsive variants.

#### [MODIFY] [company_screen.dart](file:///C:/Users/nahla/AndroidStudioProjects/constructa_app/lib/core/common/navigation_screens/company_screen.dart)
- Convert all sizes to responsive variants.

#### [MODIFY] [booking_screen.dart](file:///C:/Users/nahla/AndroidStudioProjects/constructa_app/lib/core/common/navigation_screens/booking_screen.dart)
- Convert all sizes to responsive variants.

#### [MODIFY] [project_screen.dart](file:///C:/Users/nahla/AndroidStudioProjects/constructa_app/lib/core/common/project_screen.dart)
- Convert all sizes to responsive variants.

## Verification Plan

### Manual Verification
- The user will verify the UI scaling across different devices/emulators.

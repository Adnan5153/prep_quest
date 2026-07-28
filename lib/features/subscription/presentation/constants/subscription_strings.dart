/// Centralised user-visible strings for the Subscription feature.
class SubscriptionStrings {
  const SubscriptionStrings._();

  // Hub / general
  static const String screenTitle = 'Subscription';
  static const String hubSubtitle = 'Pick the plan that fits how you prep.';
  static const String sectionPlans = 'Plans';
  static const String sectionBenefits = 'Why go Premium';
  static const String sectionRestore = 'Already subscribed?';
  static const String compareLink = 'Compare all features';
  static const String restoreCta = 'Restore purchase';
  static const String restoreDescription =
      'Already paid on another device? Restore your Prep Quest Premium '
      'entitlement in seconds.';

  // Plans screen
  static const String recommended = 'Best value';
  static const String saveBadge = 'Save %d%%';
  static const String perMonthLabel = 'per month';
  static const String perYearLabel = 'per year';
  static const String perQuarterLabel = 'per quarter';
  static const String choosePlan = 'Choose plan';
  static const String chooseFree = 'Stay on free';
  static const String currentPlan = 'Your current plan';
  static const String expiresOn = 'Renews on %s';
  static const String autoRenews = 'Auto-renewal is on. We will remind you '
      'before the next charge.';

  // Purchase flow
  static const String purchaseTitle = 'Confirm purchase';
  static const String purchaseSubtitle =
      'You are about to subscribe to Prep Quest Premium.';
  static const String confirmPurchaseCta = 'Confirm and pay';
  static const String cancelCta = 'Cancel';
  static const String processingPurchase = 'Processing your purchase…';
  static const String purchaseSuccessTitle = 'Welcome to Premium';
  static const String purchaseSuccessBody =
      'You now have unlimited access to Prep Quest Premium features.';
  static const String purchaseFailedTitle = 'Purchase did not complete';
  static const String purchaseFailedBody =
      'Something went wrong with the payment. Your card has not been charged.';
  static const String restoreSuccessTitle = 'Entitlements restored';
  static const String restoreSuccessBody =
      'Your Prep Quest Premium access is back.';
  static const String restoreNothingTitle = 'No purchases found';
  static const String restoreNothingBody =
      'We could not find an active subscription tied to your account.';
  static const String retryCta = 'Try again';
  static const String closeCta = 'Close';

  // Comparison table
  static const String compareScreenTitle = 'Plan comparison';
  static const String compareScreenSubtitle =
      'See what is included in every Prep Quest plan.';
  static const String columnFree = 'Free';
  static const String columnMonthly = 'Monthly';
  static const String columnQuarterly = 'Quarterly';
  static const String columnYearly = 'Yearly';
  static const String sectionCore = 'Core study';
  static const String sectionAi = 'AI tutor';
  static const String sectionAnalytics = 'Analytics';
  static const String sectionExtras = 'Extras';

  // Errors / loading
  static const String loadErrorTitle = 'Could not load plans';
  static const String loadErrorBody =
      'We had trouble reaching the Prep Quest subscription service. '
      'Pull down or tap retry to try again.';
  static const String processingTitle = 'Just a moment';
  static const String processingBody =
      'We are confirming your subscription with the payment provider.';
  static const String emptyTitle = 'No plans available';
  static const String emptyBody =
      'It looks like the subscription catalogue is empty right now.';
}

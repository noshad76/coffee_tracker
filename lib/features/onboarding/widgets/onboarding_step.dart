part of '../onboarding_screen.dart';

class _OnboardingStep extends StatelessWidget {
  const _OnboardingStep({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final step = state.step;
    return PopScope(
      canPop: step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && step > 0) controller.back();
      },
      child: GestureDetector(
        onHorizontalDragEnd: step > 0 && !state.saving
            ? (details) {
                final direction =
                    Directionality.of(context) == TextDirection.ltr ? 1 : -1;
                if ((details.primaryVelocity ?? 0) * direction > 600) {
                  controller.back();
                }
              }
            : null,
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 24),
                  child: Column(
                    children: [
                      if (step > 0) ...[
                        Row(
                          children: [
                            IconButton(
                              onPressed: state.saving ? null : controller.back,
                              icon: const Icon(Icons.arrow_back_rounded),
                              tooltip: 'Back',
                              color: AppTheme.paletteOf(context).textMuted,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: (step + 1) / 4,
                                  minHeight: 4,
                                  backgroundColor:
                                      AppTheme.paletteOf(context).stone800,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.paletteOf(context).brand500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) =>
                              SingleChildScrollView(
                                key: ValueKey(step),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: _stepContent(context),
                                ),
                              ),
                        ),
                      ),
                      if (state.errorMessage != null) ...[
                        _InlineError(state.errorMessage!),
                        const SizedBox(height: AppSpacing.x3),
                      ],
                      _footer(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepContent(BuildContext context) {
    return switch (state.step) {
      0 => _WelcomeContent(),
      1 => _ModeContent(state: state, controller: controller),
      2 => _LimitContent(state: state, controller: controller),
      _ => _FavoritesContent(state: state, controller: controller),
    };
  }

  Widget _footer(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final step = state.step;
    if (step == 0) {
      return Column(
        children: [
          _PrimaryButton(label: 'Get started', onPressed: controller.start),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.x1_5,
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 15,
                color: palette.stateSuccess,
              ),
              Text(
                'Everything stays on your phone. No account, no server.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.textSubtle),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      );
    }
    if (step == 1) {
      return _PrimaryButton(
        label: 'Continue',
        onPressed: controller.continueFromMode,
      );
    }
    if (step == 2) {
      return Row(
        children: [
          Expanded(
            child: _SecondaryButton(
              label: 'Skip',
              height: 52,
              onPressed: () => controller.continueFromLimit(skip: true),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _PrimaryButton(
              label: 'Continue',
              height: 52,
              onPressed: () => controller.continueFromLimit(skip: false),
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          child: _SecondaryButton(
            label: 'Skip',
            height: 52,
            onPressed: state.saving ? null : controller.finish,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _PrimaryButton(
            label: state.saving ? 'Saving…' : 'Done',
            height: 52,
            onPressed: state.saving ? null : controller.finish,
            icon: state.saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
